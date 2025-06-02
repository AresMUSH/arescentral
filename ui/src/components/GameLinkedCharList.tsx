import { Link } from "react-router-dom";
import styles from "./GameLinkedCharList.module.scss";
import { LinkedChar } from "../services/HandlesService";
import { GameLink } from "../services/GamesService";

interface GameLinkedCharListProps {
  links: GameLink[]
}

export const GameLinkedCharList = ({ links }: GameLinkedCharListProps) => {
    
  return (
    <div className={styles['linked-char-list']}>
     {
       links.map( (link : GameLink) => (
         
       <div className={styles['linked-char']} key={link.handle.id}>
         <span className={styles['handle-name']}>
           <Link to={`/handle/${link.handle.id}`}>
             @{link.handle.name}
           </Link>
         </span>
         <span className={styles['char-name-list']}>
         {
             link.chars.map( (c : LinkedChar) => (
             <span key={c.name} className={styles['char-name']}>
               {c.name}
               {c.replayed ? <i className="fas fa-users fa-xs"></i> : '' }
             </span>
           ))
         }
         </span>
       </div>
      ))
    }
    </div>
  );
}

export default GameLinkedCharList;