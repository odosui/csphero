import type { FC } from "react";
import SvgIcon, { type IconProps } from "./SvgIcon";

const CheckIcon: FC<IconProps> = (props) => (
  <SvgIcon {...props}>
    <path d="M9 16.17 4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" />
  </SvgIcon>
);

export default CheckIcon;
