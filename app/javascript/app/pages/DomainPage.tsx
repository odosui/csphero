import { useEffect, useState } from "react";
import { Outlet, useParams } from "react-router-dom";
import Api from "../api";
import NoReportsYet from "../components/NoReportsYet";
import type { Website } from "../models";

const DomainPage = () => {
  const [website, setWebsite] = useState<Website | null>(null);

  const { id } = useParams<{ id: string }>();

  useEffect(() => {
    if (!id) {
      return;
    }
    Api.websites.get(id).then((res) => {
      setWebsite(res);
    });
  }, [id]);

  if (!website) {
    return null;
  }

  return (
    <main className="domain-page">
      <div className="domain-body">
        {website.has_reports ? <Outlet /> : <NoReportsYet website={website} />}
      </div>
    </main>
  );
};

export default DomainPage;
