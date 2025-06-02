import { useLoaderData } from "react-router-dom";
import { Helmet } from "react-helmet-async";
//import styles from './GamesArchive.module.css'
import { getGames, GamesIndexResponse } from "../../services/GamesService";
import GamesTable from "../../components/GamesTable";

export async function loadClosedGames() : Promise<GamesIndexResponse> {
  const data = await getGames();  
  return data;
}

const GamesArchive = () => {

  const { games } = useLoaderData() as GamesIndexResponse;

  return (
    <>
      <Helmet>
        <title>Games Archive - AresCentral</title>
      </Helmet>
      <h1>Past Games</h1> 
      
      <p>Closed AresMUSH games are listed here. Some games have used the wiki export feature to make a static HTML archive of the web portal. If the archive is a ZIP file, just unzip the files on your local PC and then open "index.html" in your web browser. You can then browse the files offline.</p>
      
      <GamesTable games={games.closed} showActivity={false} />

      
    </>
  );
};

export default GamesArchive;