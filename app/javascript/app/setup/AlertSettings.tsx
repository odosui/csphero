import * as React from "react";
import { useState } from "react";
import Api from "../api";
import type {
  AlertSettings as Settings,
  User,
  Website,
} from "../models";
import AlertSwitch from "./AlertSwitch";
import ConfirmEmailNotice from "./ConfirmEmailNotice";

const AlertSettings: React.FC<{ website: Website; user: User }> = ({
  website,
  user,
}) => {
  const [settings, setSettings] = useState<Settings>({
    new_violation_alerts: website.new_violation_alerts,
    weekly_digest: website.weekly_digest,
  });

  const change = (changed: Partial<Settings>) => {
    setSettings({ ...settings, ...changed });
    Api.websites.update(website.id, changed);
  };

  return (
    <div className="alert-settings">
      {!user.confirmed && <ConfirmEmailNotice email={user.email} />}
      <AlertSwitch
        id="new-violation-alerts"
        label="New violations"
        description="An email when browsers report something your policy has not blocked before. At most one per hour."
        checked={settings.new_violation_alerts}
        onChange={(on) => change({ new_violation_alerts: on })}
      />
      <AlertSwitch
        id="weekly-digest"
        label="Weekly digest"
        description="Every Monday: how many reports came in, what is new and what is reported most."
        checked={settings.weekly_digest}
        onChange={(on) => change({ weekly_digest: on })}
      />
      {user.confirmed && (
        <p className="alert-recipient">Sent to {user.email}.</p>
      )}
    </div>
  );
};

export default AlertSettings;
