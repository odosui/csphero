import type { FC } from "react";
import Dropdown from "../components/Dropdown";
import TimeRangeFilter from "../TimeRangeFilter";
import type { Disposition, FilterChange, Range } from "../useFilters";
import FilterField from "./FilterField";
import SwitchFilter from "./SwitchFilter";
import TextFilter from "./TextFilter";

export type ReportFilterValues = {
  range: Range;
  disposition: Disposition;
  violatedDirective: string | null | undefined;
  blockedUri: string | null | undefined;
  sourceFile: string | null | undefined;
  filterExtensions: "0" | "1";
};

const DISPOSITIONS = [
  { id: "enforce", label: "Enforce" },
  { id: "report", label: "Report only" },
];

const ReportFilters: FC<{
  values: ReportFilterValues;
  isFiltered: boolean;
  onChange: FilterChange;
  onClear: () => void;
}> = ({ values, isFiltered, onChange, onClear }) => (
  <aside className="filter-panel">
    <header className="filters-header">
      <h2>Filters</h2>
      {isFiltered && (
        <button className="filters-clear" onClick={onClear}>
          Clear
        </button>
      )}
    </header>

    <div className="filters-group">
      <TimeRangeFilter
        value={values.range}
        onChange={(val) => onChange("range", val)}
      />
      <FilterField label="Disposition">
        <Dropdown
          value={values.disposition}
          options={DISPOSITIONS}
          onSelect={(val) => onChange("disposition", val as Disposition)}
        />
      </FilterField>
    </div>

    <div className="filters-group">
      <TextFilter
        id="filter-directive"
        label="Violated directive"
        placeholder="Any directive"
        value={values.violatedDirective}
        onChange={(val) => onChange("violated_directive", val)}
      />
      <TextFilter
        id="filter-blocked-uri"
        label="Blocked URI"
        placeholder="Any URI"
        multiline
        value={values.blockedUri}
        onChange={(val) => onChange("blocked_uri", val)}
      />
      <TextFilter
        id="filter-source-file"
        label="Source file"
        placeholder="Any file"
        multiline
        value={values.sourceFile}
        onChange={(val) => onChange("source_file", val)}
      />
    </div>

    <div className="filters-group">
      <SwitchFilter
        id="filter-extensions"
        label="Hide browser extensions"
        hint="Filter out reports caused by users' browser extensions"
        checked={values.filterExtensions === "1"}
        onChange={(on) => onChange("filter_extensions", on ? "1" : "0")}
      />
    </div>
  </aside>
);

export default ReportFilters;
