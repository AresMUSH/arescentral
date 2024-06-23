import { Game } from "../services/GamesService";
import { Link } from "react-router-dom";
import styles from "./GamesTable.module.scss";
import ActivityIndicator from "./ActivityIndicator"
import GameStatusIndicator from "./GameStatusIndicator"
import GameUpIndicator from "./GameUpIndicator"

interface GamesTableProps {
  games: Game[]
}

export const GamesTable = ({ games }: GamesTableProps) => {
  return (
  <>
    <div className={styles['games-list']}>
      <div className={styles['games-header']}>
        <div className={styles['game-name-header']}>Game</div>
        <div className={styles['game-category-header']}>Category</div>
        <div className={styles['game-activity-header']}>Activity</div>
        <div className={styles['game-status-header']}>Status</div>
      </div>

      { games.map((game : Game) => ( 
          <div className={styles['game-row']} key={game.id} >
            <div className={styles['game-name']}>
              <Link to={`/game/${game.id}`}>
                {game.name}                
              </Link>
              { game.recently_updated ? <i className={`fas fa-heartbeat ${styles['updated-icon']}`}></i> : '' }
            </div>
            <div className={styles['game-category']}>{game.category}</div>
            <div className={styles['game-activity']}>
              { game.is_open ? ( <ActivityIndicator rating={game.activity_rating} />) : null  }
            </div>
            <div className={styles['game-status']}>
               <>
                <GameStatusIndicator status={game.status} />
                
                 {
                   game.status === "Closed" ? '' : (<GameUpIndicator status={game.up_status} />)
                 }
                 
              </>
            </div>
            <div className={styles['game-visit']}>
              {
                game.up_status === 'Up' ? 
                ( 
                    <a href={game.website} target="_blank" rel="noreferrer noopener"><button className="minimal">Visit <i className="fas fa-external-link-alt" /></button></a>
                ) : null
              }
              {
                game.wiki_archive ? 
                ( 
                    <a href={game.wiki_archive} target="_blank" rel="noreferrer noopener"><button className="minimal">Archive <i className="fas fa-external-link-alt" /></button></a>
                ) : null
              }             
            </div>
          </div> 
          )) }
    </div>
  </>
  );
}

export default GamesTable;