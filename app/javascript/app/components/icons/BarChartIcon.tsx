import type { FC } from "react";
import SvgIcon, { type IconProps } from "./SvgIcon";

const BarChartIcon: FC<IconProps> = (props) => (
  <SvgIcon {...props}>
    <path d="M4 9h4v11H4zm12 4h4v7h-4zm-6-9h4v16h-4z" />
  </SvgIcon>
);

export default BarChartIcon;
