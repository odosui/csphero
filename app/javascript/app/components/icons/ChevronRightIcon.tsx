import type { FC } from "react";
import SvgIcon, { type IconProps } from "./SvgIcon";

const ChevronRightIcon: FC<IconProps> = (props) => (
  <SvgIcon {...props}>
    <path d="M10 6 8.59 7.41 13.17 12l-4.58 4.59L10 18l6-6z" />
  </SvgIcon>
);

export default ChevronRightIcon;
