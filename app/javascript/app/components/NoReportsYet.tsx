import * as React from "react";
import { Link } from "react-router-dom";
import type { Website } from "../models";

const NoReportsYet: React.FC<{ website: Website }> = ({ website }) => (
  <div className="no-reports-yet">
    <h1>No reports yet</h1>
    <p>
      {website.domain} has not sent any reports so far. Add the reporting
      header to your site, or send a test report to see how it works.
    </p>
    <Link to={`/domains/${website.id}/edit`} className="setup-link">
      Set up reporting
    </Link>
  </div>
);

export default NoReportsYet;
