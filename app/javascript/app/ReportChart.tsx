import { BarChartIcon } from "./components/icons";
import Chart from "chart.js/auto";
import * as React from "react";
import type { ReportTimeAgg } from "./models";
import { applyChartTheme, directiveColor } from "./chart/chartTheme";

const ReportChart: React.FC<{
  timeSeries: ReportTimeAgg[];
  formatAs?: "hour" | "day";
}> = ({ timeSeries, formatAs = "day" }) => {
  const canvasRef = React.useRef<HTMLCanvasElement>(null);
  const chartRef = React.useRef<Chart | null>(null);
  const [visible, setVisible] = React.useState(true);

  const directives = timeSeries[0]?.violated_directives.map((vd) => vd.name);

  const labels = timeSeries.map((ts) => {
    const date = new Date(ts.t);
    if (formatAs === "hour") {
      return `${date.getHours()}:00`;
    } else if (formatAs === "day") {
      return `${date.getDate()}/${date.getMonth() + 1}`;
    } else {
      throw new Error("Invalid formatAs");
    }
  });

  const datasets = (directives ?? []).map((d) => ({
    label: d,
    borderColor: directiveColor(d),
    backgroundColor: directiveColor(d),
    data: timeSeries.map((ts) => {
      const vd = ts.violated_directives.find((vd) => vd.name === d);
      return vd?.count ?? 0;
    }),
  }));

  const chartData = {
    labels,
    datasets,
  };

  React.useEffect(() => {
    if (canvasRef.current) {
      applyChartTheme();
      chartRef.current = new Chart(canvasRef.current, {
        type: "line",
        data: chartData,
        options: {
          interaction: { mode: "index", intersect: false },
          // room above the legend for the hide/show button
          layout: { padding: { top: 28 } },
          scales: {
            x: { grid: { display: false } },
            y: { beginAtZero: true, border: { display: false } },
          },
        },
      });
    }

    return () => {
      if (chartRef.current) {
        chartRef.current.destroy();
      }
    };
  }, [canvasRef]);

  React.useEffect(() => {
    if (!chartRef.current) return;
    chartRef.current.data = chartData;
    chartRef.current.update();
  }, [chartData]);

  return (
    <div className={`report-chart ${visible ? "" : "hidden"}`}>
      <div className="canvas-wrapper">
        <canvas ref={canvasRef}></canvas>
      </div>
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
