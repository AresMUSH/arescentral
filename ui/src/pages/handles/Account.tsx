import { useEffect } from "react";
import { useNavigate, Link } from "react-router-dom";
import { Helmet } from "react-helmet-async";
//import styles from './Account.module.scss'
import { useAuth } from '../../contexts/AuthContext';

const Account = () => {

  const navigate = useNavigate();
  const { user } = useAuth();

  useEffect(() => {
    // Check for null - undefined means not loaded yet
    if (user === null) {
      navigate('/login');
    }
  }, [user]);

  return (
    <>
      <Helmet>
        <title>Account - AresCentral</title>
      </Helmet>
      <h1>Account</h1>
      
      <p>Here you can manage your player handle account.</p>
    
      <ul>
        <li><Link to="/change-password">Change Password</Link></li>
        <li><Link to="/preferences">Manage Preferences</Link></li>
        <li><Link to="/linked-chars">Manage Linked Characters</Link></li>
        <li><Link to="/friends">Manage Friends</Link></li>
      </ul>
    </>
  );
}

export default Account;