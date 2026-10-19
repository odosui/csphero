import type { FC } from "react";
import SvgIcon, { type IconProps } from "./SvgIcon";

const ArrowDownIcon: FC<IconProps> = (props) => (
  <SvgIcon {...props}>
    <path d="m20 12-1.41-1.41L13 16.17V4h-2v12.17l-5.58-5.59L4 12l8 8z" />
  </SvgIcon>
);

export default ArrowDownIcon;
