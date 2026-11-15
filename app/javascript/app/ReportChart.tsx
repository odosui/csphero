import * as React from "react";
import { BarChartIcon } from "./components/icons";
import type { ReportTimeAgg } from "./models";
import LineChart from "./chart/LineChart";
import { buildChartData, hasAnyCount } from "./chart/buildChartData";
import type { TimeFormat } from "./chart/buildChartData";

const ReportChart: React.FC<{
  timeSeries: ReportTimeAgg[];
  formatAs?: TimeFormat;
}> = ({ timeSeries, formatAs = "day" }) => {
  const [visible, setVisible] = React.useState(true);

  const data = React.useMemo(
    () => buildChartData(timeSeries, formatAs),
    [timeSeries, formatAs]
  );

  if (!hasAnyCount(data)) return null;

  return (
    <div className={visible ? "report-chart" : "report-chart hidden"}>
      {visible && <LineChart data={data} />}
      <button
        className="toggle-show-btn humble"
        onClick={() => setVisible(!visible)}
      >
        <BarChartIcon />
        {visible ? "Hide chart" : "Show chart"}
      </button>
    </div>
  );
};

export default React.memo(ReportChart);
