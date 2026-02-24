import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useLoaderData, Link } from "react-router-dom";
import { Helmet } from "react-helmet-async";
//import styles from './GamesAdmin.module.scss'
import { Game } from "../../services/GamesService";
import { getGamesOrphans, updateGameStatus, GamesOrphansResponse } from "../../services/AdminService";
import GameStatusIndicator from "../../components/GameStatusIndicator"
import GameUpIndicator from "../../components/GameUpIndicator"
import { isErrorResponse } from "../../services/RequestHelper";
import Label from "../../components/Label"

export async function loadGamesOrphans() : Promise<GamesOrphansResponse> {
  const data = await getGamesOrphans();  
  return data;
}

const GamesOrphans = () => {

  const [completeMessage, setCompleteMessage] = useState<string>("");
  const navigate = useNavigate();

  async function onRetire(game) {
    
    setCompleteMessage('');
    try {
      const response = await updateGameStatus(game.id, "Closed", game.is_public, game.wiki_archive, true);
      if (isErrorResponse(response)) {
        setCompleteMessage(response.error);
      } else
      {
        navigate('/admin/games/orphans');      
      }
    } catch(e : any) {
      console.log(e);
      navigate('/error');
    }    
  }
  
  const { games } = useLoaderData() as GamesOrphansResponse;
  return (
    <>
      <Helmet>
        <title>Games Orphans - AresCentral</title>
      </Helmet>
      <h1>Orphans</h1> 
      
      <table>
        <thead>
          <tr>
            <th>Game</th>
            <th>Address</th>
            <th>Status</th>
            <th>Up</th>
            <th>ID</th>
            <th>Last CheckIn</th> 
    <th></th>
            <th>&nbsp;</th>
          </tr>
        </thead>
        <tbody>
          { games.map((game : Game) => ( 
            <tr key={game.id}>
              <td><Link to={`/game/${game.id}`}>{game.name}</Link></td>
              <td><a href={`${game.website}`} target="blank">{game.website}</a></td>
              <td><GameStatusIndicator status={game.status} /></td>
              <td><GameUpIndicator status={game.up_status} /></td>
              <td>{game.id}</td>
              <td>{game.last_ping}</td>
            <td>{game.wiki_archive}</td>
              <td>
              <button onClick={() => onRetire(game)}>Retire</button>
              </td>
            </tr>
          )) }

        </tbody>
      </table>

      { completeMessage ? <p className="note"><b>{completeMessage}</b></p> : '' }
            
    </>
  );
};

export default GamesOrphans;