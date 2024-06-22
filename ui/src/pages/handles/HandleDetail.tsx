import { useState } from "react";
import { useLoaderData, useNavigate } from "react-router-dom";
import { Helmet } from "react-helmet-async";
import styles from './HandleDetail.module.scss'
import { getHandle, HandleResponse } from "../../services/HandlesService";
import { banPlayer, resetPlayerPassword } from "../../services/AdminService";
import { HandleLinkedCharList } from "../../components/HandleLinkedCharList";
import { useAuth } from '../../contexts/AuthContext';
import { isErrorResponse } from "../../services/RequestHelper";
import Markdown from 'react-markdown'
import type { ActionFunction } from "react-router";

export const loadHandle : ActionFunction = async({params}) => {
  const data = await getHandle(params.handleId || "");
  return data;
}

const HandleDetail = () => {

  const { handle } = useLoaderData() as HandleResponse;
  const { user } = useAuth();
  const [completeMessage, setCompleteMessage] = useState<string>('');
  const navigate = useNavigate();

  const onBanPlayer = async (banState : boolean) => {
    try {
      setCompleteMessage("");
      const response = await banPlayer(handle.id, banState);
      if (isErrorResponse(response)) {
        setCompleteMessage(response.error);
      } else {
        setCompleteMessage("Player banned.");
      }
    } catch(e : any) {
      console.log(e);
      navigate('/error');
    }
  }
  
  const onResetPassword = async () => {
    try {
      setCompleteMessage("");
      const response = await resetPlayerPassword(handle.id);
      if (isErrorResponse(response)) {
        setCompleteMessage(response.error);
      } else {      
        setCompleteMessage(`Password reset to ${response.password}`);
      }
    } catch(e : any) {
      console.log(e);
      navigate('/error');
    }
  }
  
  return (
    <>
      <Helmet>
        <title>{handle.name} - AresCentral</title>
      </Helmet>
      
      <h1>{handle.name}</h1> 
      
      { handle.banned ? <div className="warning">This player has been banned from the AresCentral forums.</div> : '' }
      
      <img className={styles['handle-profile-image']} src={handle.image_url} />
      
      <Markdown children={handle.profile} />
          
            
      <h2>Characters</h2>
      
      <p><i className="fas fa-users"></i> = Character played by multiple players, such as a reclaimed roster.</p>
      

      <h3>Current</h3>
      
      <HandleLinkedCharList links={handle.current_chars} />
      
      <h3>Past</h3>      
      
      <HandleLinkedCharList links={handle.past_chars} />
      
      
      {
        user && user.is_admin ? <>
         <div className={`note ${styles['admin-area']}`}>
           <h3>Admin Info</h3>
            <p><b>Last IP:</b> {handle.last_ip}</p>
            <p><b>Email:</b> {handle.email}</p>
            <p><b>Security Q:</b> {handle.security_question}</p>


            <div className={styles['action-buttons']}>          
              { handle.banned ? (
                   <button onClick={() => onBanPlayer(false)} className="warn">Un-Ban <i className="fa fa-check-circle" /></button>
                ) : (
                 <button onClick={() => onBanPlayer(true)} className="warn">Ban <i className="fa fa-ban" /></button>
                )
              }
              <button onClick={onResetPassword}>Reset Password <i className="fa fa-unlock-alt" /></button>
            </div>
            
            { completeMessage ? <p className={styles['admin-note']}><b>{completeMessage}</b></p> : '' }
        
          </div>
        </> : ''
        
      }
    </>
  );
};

export default HandleDetail;