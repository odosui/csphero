import type { FC } from "react";
import SvgIcon, { type IconProps } from "./SvgIcon";

const ChevronDownIcon: FC<IconProps> = (props) => (
  <SvgIcon {...props}>
    <path d="M16.59 8.59 12 13.17 7.41 8.59 6 10l6 6 6-6z" />
  </SvgIcon>
);

export default ChevronDownIcon;
