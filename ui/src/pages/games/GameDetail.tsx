import { useLoaderData, Link } from "react-router-dom";
import { Helmet } from "react-helmet-async";
import { getGame, GameResponse } from "../../services/GamesService";
import ActivityIndicator from "../../components/ActivityIndicator";
import GameStatusIndicator from "../../components/GameStatusIndicator"
import GameUpIndicator from "../../components/GameUpIndicator"
import { GameLinkedCharList } from "../../components/GameLinkedCharList";
import styles from './GameDetail.module.scss'
import Markdown from 'react-markdown'
import { useAuth } from '../../contexts/AuthContext';
import type { ActionFunction } from "react-router";
import dayjs from "dayjs";

export const loadGame : ActionFunction = async({params}) => {
  const data = await getGame(params.gameId || '');
  return data;
}

const GameDetail = () => {
  const { game } = useLoaderData() as GameResponse;
  const { user } = useAuth();

  return (
    <>
      <Helmet>
        <title>{game.name} - AresCentral</title>
      </Helmet>
      <h1>{game.name}</h1> 
      
      
      <Markdown children={game.description} />
      
      <hr/>
            
      <h2>Status</h2>
      
      {
      game.wiki_archive ? 
        (<div className={`note ${styles['archive-warning']}`}>
  
        <p><b>This game has closed.</b></p>

        <p>A partial archive of the web portal is available.  If the archive is a ZIP file, just unzip the files on your local PC and then open "index.html" in your web browser. You can then browse the files offline. </p>
        
        <p><a className={styles['button']} target="_blank" rel="noopener noreferrer" href={game.wiki_archive}>View Archive</a></p>
  
        </div>) : ( <></> )

      }
      
      <GameStatusIndicator status={game.status} />
      <GameUpIndicator status={game.up_status} />
      
      <p>{game.name} last checked in with AresCentral on {game.last_ping}.</p>
      
      <hr/>
      
      <h2>Game Info</h2>
            
      <p><b>Website:</b> <a href={game.website} target="_blank" rel="noopener noreferrer">{game.website}</a></p>
      
      <p><b>Client Address:</b> {game.host} port {game.port}</p>
      
      <p><b>Category:</b> {game.category}</p>
            
      
      <p><b>Status:</b> {game.status}</p>

      <p><b>Created:</b> {dayjs(game.created_at).format("MMM DD, YYYY")}</p>
      
      <hr/>
    
     {
       game.is_open ? 
       (
         <>
           <h2>Activity</h2>

           <p><b>Overall:</b> <ActivityIndicator rating={game.activity_rating} /></p>
     
           <p>Average logins over the last couple weeks at different time periods. All times are listed in EST.</p>
           <p><i className="fa fa-star"></i>=5 players</p>

          <table className={styles['activity-table']}>
            <tbody>
              <tr key="time-header">
                <td key='spacer'></td>
                { game.activity_time_titles.map((t : string) => (<td key={`time${t}`}>{t}</td>)) }
              </tr>
        
              { game.activity_day_titles.map((d : string) => 
           
                  (<tr key={`day${d}`}>
                  <td key={`header${d}`}>{d}</td>
                    { game.activity_time_titles.map((t : string) => 
                      (<td key={`time${d}${t}`}><ActivityIndicator rating={game.activity_table[d][t]} /></td>)) 
                    }
                  </tr>
                  )) 
              }
        
            </tbody>
          </table>
        </>
      ) : <></>
    }
    
    <h2>Players</h2>
        
    <p><i className="fas fa-users"></i> = Character played by multiple players, such as a reclaimed roster.</p>
    
    <h3>Current</h3>
    
    <GameLinkedCharList links={game.current_chars} />
    
    <h3>Past</h3>
        
    <GameLinkedCharList links={game.past_chars} />
    
    {
          user && user.is_admin ? 
           <div className={`note ${styles['admin-area']}`}><Link to={`/admin/game/${game.id}/edit`}>Edit</Link></div> :
          ''
    }
    </>
  );
};

export default GameDetail;