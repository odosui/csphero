import type { ChartData } from "chart.js";
import type { ReportTimeAgg } from "../models";
import { directiveColor } from "./chartTheme";

export type TimeFormat = "hour" | "day";

function formatLabel(iso: string, format: TimeFormat) {
  const date = new Date(iso);
  if (format === "hour") {
    return `${String(date.getHours()).padStart(2, "0")}:00`;
  }
  return `${date.getDate()}/${date.getMonth() + 1}`;
}

export function buildChartData(
  timeSeries: ReportTimeAgg[],
  format: TimeFormat
): ChartData<"line"> {
  const directives =
    timeSeries[0]?.violated_directives.map((vd) => vd.name) ?? [];

  return {
    labels: timeSeries.map((ts) => formatLabel(ts.t, format)),
    datasets: directives.map((name) => ({
      label: name,
      borderColor: directiveColor(name),
      backgroundColor: directiveColor(name),
      data: timeSeries.map(
        (ts) =>
          ts.violated_directives.find((vd) => vd.name === name)?.count ?? 0
      ),
    })),
  };
}

export function hasAnyCount(data: ChartData<"line">) {
  return data.datasets.some((d) => d.data.some((count) => Number(count) > 0));
}
