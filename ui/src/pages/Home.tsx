import { Link } from "react-router-dom";
import { Helmet } from "react-helmet-async";
import { useAuth } from '../contexts/AuthContext';
import styles from './Home.module.scss'

const Home = () => {

  const { user } = useAuth();

  return (
   
   <>
     <Helmet>
       <title>Home - AresCentral</title>
     </Helmet>
     <p>Welcome to Ares Central, the social hub for <a href="http://www.aresmush.com">AresMUSH</a>.  This is where you can find AresMUSH games and players.</p>

     <p>You can also manage your AresMUSH <b>Player Handle</b>.  Handles bring a taste of social media to MUSHing, allowing you to identify yourself as a player and not just a character.  Handles are an <b>optional</b> OOC identity that follows you from game to game.  Handles also help you keep track of your friends across games and let you share a public player profile here on AresCentral.  Read all about handles in the Ares <a href="http://www.aresmush.com/handles">Player Handle Guide</a></p>


     {
     user ? ('') : 
       (       
         <div className={styles['cta']}>
           <Link to="/register"><button>Create Your Player Handle</button></Link>
           <p>If you already have a handle, you can <Link to="/login">log in</Link>.</p>
         </div>
       )
     }
   </>
  )
};

export default Home;