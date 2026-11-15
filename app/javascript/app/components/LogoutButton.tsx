import type { FC } from "react";
import { LogoutIcon } from "./icons";

function csrfToken() {
  return (
    document
      .querySelector<HTMLMetaElement>('meta[name="csrf-token"]')
      ?.content ?? ""
  );
}

const LogoutButton: FC = () => (
  <form method="post" action="/users/sign_out" className="logout-form">
    <input type="hidden" name="_method" value="delete" />
    <input type="hidden" name="authenticity_token" value={csrfToken()} />
    <button type="submit" className="navlink">
      <LogoutIcon />
      Log out
    </button>
  </form>
);

export default LogoutButton;
