import { Link } from "react-router-dom";
import styles from "./HandleLinkedCharList.module.scss";
import { HandleLink, LinkedChar } from "../services/HandlesService";

interface HandleLinkedCharListProps {
  links: HandleLink[]
}

export const HandleLinkedCharList = ({ links }: HandleLinkedCharListProps) => {
  return (
    <div className={styles['linked-char-list']}>
     {
       links.map( (link : HandleLink) => (
       <div className={styles['linked-char']} key={link.game.id}>
         <span className={styles['game-name']}>
           <Link to={`/game/${link.game.id}`}>
             {link.game.name}
           </Link>
         </span>
         <span className={styles['char-name-list']}>
         {
             link.chars.map( (c : LinkedChar) => (
             <span key={c.id} className={styles['char-name']}>
               {c.name}
               {c.replayed ? <i className="fas fa-users"></i> : '' }
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

export default HandleLinkedCharList;