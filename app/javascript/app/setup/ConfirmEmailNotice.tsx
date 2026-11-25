import * as React from "react";
import { useState } from "react";
import Api from "../api";

const ConfirmEmailNotice: React.FC<{ email: string }> = ({ email }) => {
  const [sent, setSent] = useState(false);

  const resend = async () => {
    await Api.users.resendConfirmation();
    setSent(true);
  };

  return (
    <div className="confirm-email-notice">
      <p>
        Alerts only go to confirmed addresses. Follow the link we emailed to{" "}
        <b>{email}</b> to start getting them.
      </p>
      <button type="button" className="humble" onClick={resend} disabled={sent}>
        {sent ? "Confirmation email sent" : "Resend the confirmation email"}
      </button>
    </div>
  );
};

export default ConfirmEmailNotice;
