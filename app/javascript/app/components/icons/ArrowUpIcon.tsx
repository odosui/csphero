import type { FC } from "react";
import SvgIcon, { type IconProps } from "./SvgIcon";

const ArrowUpIcon: FC<IconProps> = (props) => (
  <SvgIcon {...props}>
    <path d="m4 12 1.41 1.41L11 7.83V20h2V7.83l5.58 5.59L20 12l-8-8z" />
  </SvgIcon>
);

export default ArrowUpIcon;
