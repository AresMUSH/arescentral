import { useLoaderData, Link } from "react-router-dom";
import { Helmet } from "react-helmet-async";
//import styles from './GamesAdmin.module.scss'
import { Game } from "../../services/GamesService";
import { getGamesAdmin, GamesAdminResponse } from "../../services/AdminService";
import GameStatusIndicator from "../../components/GameStatusIndicator"
import GameUpIndicator from "../../components/GameUpIndicator"
import Label from "../../components/Label"

export async function loadGamesAdmin() : Promise<GamesAdminResponse> {
  const data = await getGamesAdmin();  
  return data;
}

const GamesAdmin = () => {

  const { games } = useLoaderData() as GamesAdminResponse;
  return (
    <>
      <Helmet>
        <title>Games Admin - AresCentral</title>
      </Helmet>
      <h1>Games</h1> 
      
      <table>
        <thead>
          <tr>
            <th>Game</th>
            <th>Address</th>
            <th>Category</th>
            <th>Privacy</th>
            <th>Status</th>
            <th>Up</th>
            <th>ID</th>
            <th>Last CheckIn</th> 
          </tr>
        </thead>
        <tbody>
          { games.map((game : Game) => ( 
            <tr key={game.id}>
              <td><Link to={`/game/${game.id}`}>{game.name}</Link></td>
              <td>{game.website}</td>
              <td>{game.category}</td>
              <td> {
               game.is_open ? <Label status="open">Public</Label> : null
              }
              </td>
              <td><GameStatusIndicator status={game.status} /></td>
              <td><GameUpIndicator status={game.up_status} /></td>
              <td>{game.id}</td>
              <td>{game.last_ping}</td>
            </tr>
          )) }

        </tbody>
      </table>
            
    </>
  );
};

export default GamesAdmin;