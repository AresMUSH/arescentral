import React, { useEffect, useState } from "react";
import { useNavigate, Link } from "react-router-dom";
import { Helmet } from "react-helmet-async";
import styles from './LinkedCharacters.module.scss'
import { useAuth } from '../../contexts/AuthContext';
import { LinkedChar, getLinkedChars, generateLinkCode, resetLinkPassword, unlinkCharacter } from "../../services/HandlesService";
import { isErrorResponse } from "../../services/RequestHelper";

const LinkedCharacters = () => {

  const [error, setError] = useState<React.ReactNode>("");
  const [linkCodes, setLinkCodes] = useState<string[]>([]);
  const [links, setLinks] = useState<LinkedChar[]>([]);
  const [completeMessage, setCompleteMessage] = useState<string>("");
  const navigate = useNavigate();
  const { user } = useAuth();
  
  useEffect(() => {
    if (user === null) {
      navigate('/login');
    } 
    else if (user === undefined)
    {
      // Hasn't been loaded yet - do nothing.
    }
    else {
      const fetchData = async () => {
        try {
          const response = await getLinkedChars();
          setLinks(response.links);
          setLinkCodes(response.codes);
        } catch(e : any) {
          console.log(e);
          navigate('/error');
        }
      }
      fetchData();
    }
  }, [user]);

   const onGenerateCode = async () => {
     try {
       setCompleteMessage("");
       setError("");
       const response = await generateLinkCode();
       if (isErrorResponse(response)) {
         setError(response.error);
       } else {
         setLinkCodes(response.codes);
         setCompleteMessage("Code generated.");
       }
     } catch(e : any) {
       console.log(e);
       navigate('/error');
     }
   }
     
    const onResetPassword = async (linkId : string) => {
      try {
         setCompleteMessage("");
         setError("");
         const response = await resetLinkPassword(linkId);
         if (isErrorResponse(response)) {
           setError(response.error);
         } else
         {
           setLinks(response.links);
           setCompleteMessage("Temporary password set.");
         }
       } catch(e : any) {
         console.log(e);
         navigate('/error');
       }
    }

     const onUnlinkChar = async (linkId : string) => {
       try { 
         setCompleteMessage("");
         setError("");
         const response = await unlinkCharacter(linkId);
         if (isErrorResponse(response)) {
           setError(response.error);
         }
         else {
           setLinks(response.links);
           setCompleteMessage("Character unlinked.");
         }
       } catch(e : any) {
         console.log(e);
         navigate('/error');
       }
     }
     
   return (
    <>
      <Helmet>
        <title>Linked Characters - AresCentral</title>
      </Helmet>
      
      <h1>Linked Characters</h1>
      
      <p>Manage the characters linked to your player handle.</p>
     
     <h2>Link Codes</h2>
     
     <p>Use one of these codes to link a character to your handle. Each code may only be used once. Log into an AresMUSH game with the character you wish to link and type the command: <code>handle/link &lt;handle name&gt;=&lt;code&gt;</code>.</p>
     
     {
       linkCodes ? <ul>
       {
         linkCodes.map( code => <li key={code}>{code}</li> )
       } 
       </ul> : <p><b>No link codes available.</b></p>
     }
 
     <button onClick={onGenerateCode}>Generate New Code <i className="fa fa-link" /></button>

     {
       error ? <div className="warning">{error}</div> : ''
     }
     
     {
       completeMessage ? <div className="note">{completeMessage}</div> : ''
     }
            
     <h2>Linked Characters</h2>
      
    {
        links.map(link => 
          <div className={styles['link-entry']} key={link.id}>

           <div>
            {link.name}@<Link to={`/game/${link.game.id}`}>{link.game.name}</Link>
           </div>
          
          {
            link.temp_password ? <div className="note">Temp Password: {link.temp_password}. Use this to log into the game and then reset it there.</div> : ''
          }
          
            <div className={styles['link-actions']}>
              <button className="small" onClick={() => onResetPassword(link.id)}>Reset Password <i className="fa fa-unlock" /></button>
              <button className="small warn" onClick={() => onUnlinkChar(link.id)}>Unlink <i className="fa fa-ban" /></button>
            </div>
          </div>
  
        )
        
    }

    </>
  );
}

export default LinkedCharacters;