import * as React from "react";
import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import ReportDetails from "./ReportDetails";
import DirectiveBadge from "./components/DirectiveBadge";
import Spinner from "./Spinner";
import Table from "./Table";
import ReportFilters from "./filters/ReportFilters";
import Api from "./api";
import type { Report, ReportTimeAgg } from "./models";
import useFilters from "./useFilters";
import type { Disposition, Range } from "./useFilters";
import { formatDate, source } from "./utils";
import { ArrowDownIcon, ArrowUpIcon } from "./components/icons";
import ReportChart from "./ReportChart";

const AllReports: React.FC<{}> = ({}) => {
  const [reports, setReports] = useState<Report[]>([]);
  const [timeSeries, setTimeSeries] = useState<ReportTimeAgg[]>([]);
  const [loading, setLoading] = useState(false);
  const [expandedIds, setExpandedIds] = useState<string[]>([]);
  const [page, setPage] = useState(0);
  const [hasMore, setHasMore] = useState(true);

  const listAbort = React.useRef<AbortController | null>(null);
  const tsAbort = React.useRef<AbortController | null>(null);

  const {
    filters: {
      range,
      disposition,
      violatedDirective,
      blockedUri,
      sourceFile,
      filterExtensions,
    },
    onFilterChange,
    isFiltered,
    clearFilters,
  } = useFilters([
    "range",
    "disposition",
    "violated_directive",
    "blocked_uri",
    "source_file",
    "filter_extensions",
  ]);

  const { id: websiteId } = useParams<{ id: string }>();

  async function loadReports(
    websiteId: number | string,
    range: Range,
    disposition: Disposition,
    violatedDirective: string | null,
    blockedUri: string | null,
    sourceFile: string | null,
    filterExtensions: "0" | "1",
    page: number
  ) {
    if (page === 0) {
      setReports([]);
    }
    setPage(page);
    setLoading(true);

    if (listAbort.current) {
      listAbort.current.abort();
    }

    listAbort.current = new AbortController();

    const res = await Api.reports.list(
      websiteId,
      {
        range,
        disposition,
        violatedDirective,
        blockedUri,
        sourceFile,
        filterExtensions,
      },
      page,
      listAbort.current.signal
    );
    setLoading(false);
    setHasMore(res.length >= 50);
    setReports([...(page === 0 ? [] : reports), ...res]);
  }

  async function loadTimeSeries(
    websiteId: number | string,
    range: Range,
    disposition: Disposition,
    violatedDirective: string | null,
    blockedUri: string | null,
    sourceFile: string | null,
    filterExtensions: "0" | "1"
  ) {
    // setLoading(true);

    if (tsAbort.current) {
      tsAbort.current.abort();
    }

    tsAbort.current = new AbortController();

    const res = await Api.reports.time_series(
      websiteId,
      {
        range,
        disposition,
        violatedDirective,
        blockedUri,
        sourceFile,
        filterExtensions,
      },
      tsAbort.current.signal
    );

    setTimeSeries(res);

    // setLoading(false);
  }

  const handleFiltersChange = async () => {
    if (!websiteId) return;
    loadReports(
      websiteId,
      range,
      disposition,
      violatedDirective ?? null,
      blockedUri ?? null,
      sourceFile ?? null,
      filterExtensions,
      0
    );

    loadTimeSeries(
      websiteId,
      range,
      disposition,
      violatedDirective ?? null,
      blockedUri ?? null,
      sourceFile ?? null,
      filterExtensions
    );
  };

  const handleNextPage: React.MouseEventHandler<HTMLButtonElement> = (e) => {
    e.preventDefault();
    if (!websiteId) return;
    loadReports(
      websiteId,
      range,
      disposition,
      violatedDirective ?? null,
      blockedUri ?? null,
      sourceFile ?? null,
      filterExtensions,
      page + 1
    );
  };

  useEffect(() => {
    handleFiltersChange();
  }, [
    websiteId,
    range,
    disposition,
    violatedDirective,
    blockedUri,
    sourceFile,
    filterExtensions,
  ]);

  return (
    <div className="all-reports">
      <ReportFilters
        values={{
          range,
          disposition,
          violatedDirective,
          blockedUri,
          sourceFile,
          filterExtensions,
        }}
        isFiltered={isFiltered}
        onChange={onFilterChange}
        onClear={clearFilters}
      />
      <div className="data-view">
        <ReportChart
          timeSeries={timeSeries}
          formatAs={range === "24h" ? "hour" : "day"}
        />

        {reports.length === 0 && !loading && (
          <div className="no-data">
            {isFiltered
              ? "No reports match these filters."
              : "No new violations have been reported."}
          </div>
        )}
        {(reports.length > 0 || (reports.length === 0 && loading)) && (
          <div className="table-view">
            <Table
              data={reports}
              getId={(v) => v.id.toString()}
              columns={[
                {
                  key: "created_at",
                  label: "Reported",
                  render: (v: Report) =>
                    v.created_at ? (
                      <span className="secondary">
                        {formatDate(v.created_at)}
                      </span>
                    ) : (
                      ""
                    ),

                  width: "136px",
                },
                // {
                //   key: "disposition",
                //   label: "Disposition",
                //   render: (v: Report) => (
                //     <div
                //       className={[
                //         "disposition-badge",
                //         v.disposition?.toLowerCase(),
                //       ].join(" ")}
                //     >
                //       {v.disposition}
                //     </div>
                //   ),
                //   width: "128px",
                // },
                {
                  key: "violated_directive",
                  label: "Directive",
                  render: (v: Report) => (
                    <DirectiveBadge name={v.violated_directive} />
                  ),
                  width: "152px",
                },
                {
                  key: "blocked_uri",
                  label: "Blocked URI",
                  render: (v: Report) => v.blocked_uri,
                  width: "2fr",
                },
                {
                  key: "source",
                  label: "Source",
                  render: (v: Report) => source(v),
                },
                {
                  key: "view_all_link",
                  label: "",
                  render: (v: Report) => (
                    <a
                      href="#"
                      className="action-link details-link"
                      onClick={(e) => {
                        e.preventDefault();
                        if (expandedIds.includes(v.id.toString())) {
                          setExpandedIds(
                            expandedIds.filter((id) => id !== v.id.toString())
                          );
                        } else {
                          setExpandedIds([...expandedIds, v.id.toString()]);
                        }
                      }}
                    >
                      Details
                      {expandedIds.includes(v.id.toString()) ? (
                        <ArrowUpIcon />
                      ) : (
                        <ArrowDownIcon />
                      )}
                    </a>
                  ),
                  align: "right",
                  width: "112px",
                },
              ]}
              renderExpanded={(v: Report) => {
                return <ReportDetails report={v} />;
              }}
              expandedIds={expandedIds}
            />

            {loading && <Spinner />}

            {!loading && reports.length > 0 && hasMore && (
              <div className="pagination">
                <button className="btn" onClick={handleNextPage}>
                  Load more
                </button>
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  );
};

export default AllReports;
