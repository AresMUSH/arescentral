import { Link } from "react-router-dom";
import styles from "./Navbar.module.scss";


export const Navbar = () => {

  return (
    <nav className={styles['main-nav']}>
      <ul>
        <li>
          <Link to="/">Home</Link>
        </li>
        <li>
          <Link to="/games">Games</Link>
        </li> 
        <li>
          <Link to="/handles">Handles</Link>
        </li>   
        <li>
          <Link to="/plugins">Plugins</Link>
        </li>
        <li>
          <Link to="/themes">Themes</Link>
        </li> 
        <li>
          <Link to="/logcleaner">Log Cleaner</Link>
        </li> 
        <li>
          <a href="https://forum.aresmush.com/" target='_blank' rel='noopener noreferrer'>Forum</a>
        </li>   
        <li>
          <a href="https://aresmush.com/" target='_blank' rel='noopener noreferrer'>AresMUSH.com</a>
        </li>  
      </ul>
    </nav>
  );
}

export default Navbar;


    