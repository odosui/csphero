import Chart from "chart.js/auto";
import type { ChartData } from "chart.js";
import { useEffect, useRef } from "react";
import type { FC } from "react";
import { applyChartTheme } from "./chartTheme";

// Mounted only while visible with data, so the canvas is created at its real
// size and never grows out of a 0×0 box.
const LineChart: FC<{ data: ChartData<"line"> }> = ({ data }) => {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const chartRef = useRef<Chart<"line"> | null>(null);

  useEffect(() => {
    if (!canvasRef.current) return;
    applyChartTheme();
    chartRef.current = new Chart(canvasRef.current, {
      type: "line",
      data,
      options: {
        interaction: { mode: "index", intersect: false },
        // room above the legend for the hide/show button
        layout: { padding: { top: 28 } },
        scales: {
          x: {
            grid: { display: false },
            ticks: { maxRotation: 0, autoSkipPadding: 16 },
          },
          y: {
            beginAtZero: true,
            border: { display: false },
            ticks: { precision: 0 },
          },
        },
      },
    });
    return () => chartRef.current?.destroy();
  }, []);

  useEffect(() => {
    if (!chartRef.current) return;
    chartRef.current.data = data;
    chartRef.current.update();
  }, [data]);

  return (
    <div className="canvas-wrapper">
      <canvas ref={canvasRef} />
    </div>
  );
};

export default LineChart;
