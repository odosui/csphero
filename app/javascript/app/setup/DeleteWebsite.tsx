import * as React from "react";
import { useState } from "react";
import { useNavigate } from "react-router-dom";
import Api from "../api";
import type { Website } from "../models";

const DeleteWebsite: React.FC<{
  website: Website;
  onDeleted: () => Promise<void>;
}> = ({ website, onDeleted }) => {
  const [confirming, setConfirming] = useState(false);
  const [deleting, setDeleting] = useState(false);
  const navigate = useNavigate();

  const deleteWebsite = async () => {
    setDeleting(true);
    await Api.websites.destroy(website.id);
    await onDeleted();
    navigate("/");
  };

  if (!confirming) {
    return (
      <div className="delete-website">
        <p>
          Removes {website.domain} and every report collected for it. Reports
          still sent to its endpoint afterwards are rejected.
        </p>
        <button
          type="button"
          className="humble"
          onClick={() => setConfirming(true)}
        >
          Delete website
        </button>
      </div>
    );
  }

  return (
    <div className="delete-website confirming">
      <p>
        Delete <b>{website.domain}</b> and all of its reports? This cannot be
        undone.
      </p>
      <div className="delete-website-actions">
        <button
          type="button"
          className="danger"
          onClick={deleteWebsite}
          disabled={deleting}
        >
          {deleting ? "Deleting…" : "Yes, delete it"}
        </button>
        <button
          type="button"
          className="humble"
          onClick={() => setConfirming(false)}
          disabled={deleting}
        >
          Cancel
        </button>
      </div>
    </div>
  );
};

export default DeleteWebsite;
