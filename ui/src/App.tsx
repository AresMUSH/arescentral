import { Outlet, Link, ScrollRestoration, useNavigate } from "react-router-dom";
import { HelmetProvider } from 'react-helmet-async';
import aresLogo from './assets/logo.png'
import './App.scss'
import Navbar from './components/Navbar';
import { useAuth } from './contexts/AuthContext';

const App = () => {
    
  const { user, logout} = useAuth();
  const navigate = useNavigate();
  
  const handleLogout = () => {
    logout();
    navigate("/");
  }
  
  return (

    <HelmetProvider>  
       <div className="titlebox">
         <div className="logo-container">
           <a href="https://arescentral.aresmush.com">
             <img src={aresLogo} className="logo" alt="AresMUSH logo" />
           </a>
           <h1 className="site-title">AresCentral</h1> 
         </div>
           
         
         <div className="user-actions">
           {
           user ? 
             ( <>
                 <span>Welcome {user.name}!</span>
                 <div className="account-actions">
                   <Link to={`/handle/${user.name}`} className="button minimal">Profile</Link>
                   &nbsp;
                   |
                   &nbsp;
                   <Link to="/account" className="button minimal">My Account</Link>
                   
                   { user.is_admin ? <>
                     &nbsp;
                     |
                     &nbsp;
                     <Link to="/admin" className="button minimal">Admin</Link>
                     </> : '' }
                     
                     &nbsp;
                     |
                     &nbsp;
                     <button className="button minimal" onClick={handleLogout}>Logout</button>
                   
                 </div>
                 
                </>
              ) : 
             ( <Link to="/login">Login</Link>)
           }
         </div>
           
       </div>
 
       <Navbar />

        <div className="container">
          <Outlet />
        </div>
  
        <div className="footer">
          <p>
            <a href="http://www.aresmush.com/privacy" target='_blank' rel='noopener noreferrer'>Privacy Policy</a>&nbsp; | &nbsp;
            <a href="/terms">Terms of Use</a>&nbsp; | &nbsp;
            <a href="https://www.aresmush.com/conduct.html" target='_blank' rel='noopener noreferrer'>Community Code of Conduct</a>
          </p>

          <p>Report bugs or offensive content to faraday@aresmush.com. </p>
        </div>

        <ScrollRestoration />
      </HelmetProvider>
  );
}
export default App;