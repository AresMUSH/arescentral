import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Helmet } from "react-helmet-async";
//import styles from './LogCleaner.module.scss'
import { useFormik } from "formik";
import { formatRPLog } from "../../services/GamesService";
import { isErrorResponse } from "../../services/RequestHelper";

const LogCleaner = () => {

  const [completeMessage, setCompleteMessage] = useState<string>("");
  const [formattedLog, setFormattedLog] = useState<string>("");
  const navigate = useNavigate();

  interface RPLog {
    log: string;
    logFormat: string;
  }
  const formik = useFormik<RPLog>({
    initialValues: {
      log: '',
      logFormat: 'mush'
    },

    onSubmit: (async (values) => {
      setCompleteMessage('');
      try {
        const response = await formatRPLog(values.log, values.logFormat);
        
        if (isErrorResponse(response)) {
          setCompleteMessage(response.error);
        } else
        {
          setCompleteMessage('Log formatted.');        
          setFormattedLog(response.log);
        }
        
      } catch(e : any) {
        console.log(e);
        navigate('/error');
      }
      
    }),
    validateOnChange: false,
  });
  
  
  return (
   
   <>
     <Helmet>
       <title>Log Cleaner - AresCentral</title>
     </Helmet>
     
     
    <h1>Roleplay Log Cleaner</h1>

    <p>The log cleaner takes raw log files (presumably captured by your favorite MU* client) and strips out junk such as pages, channels, OOC chatter, coming/going messages, and various other soft- and hard-coded command spam.  It also adds blank lines as necessary so everything is spaced out nicely.</p>

    <p>If you are using the FS3 Combat Wiki format for Wikidot, you should add a .fs3combat class to your wiki CSS.</p>

    <div className="warning"><b>Note!</b> Keep copies of your original/raw log files until you have verified that the log has been formatted correctly and no data was lost.</div>

    
    <form onSubmit={formik.handleSubmit}>
    
      <div className="form-field-group">    
        <label htmlFor="status">Format:</label>
        <select 
           id="logFormat"
           name="logFormat" 
          onChange={formik.handleChange}
           value={formik.values.logFormat} 
        >
          <option value="mush" key="mush">MUSH - Excludes MUSH-style channels. &lt;Public&gt; Faraday says, "Hello."  Covers PennMUSH and AresMUSH.</option>
          <option value="mux" key="mux">MUX - Excludes MUX-style channels. [Public] Faraday says, "Hello."</option>
          <option value="ares_fs3_combat_wiki" key="ares_fs3_combat_wiki">Ares FS3 Combat Wiki - FS3 combat logs for AresMUSH with pretty wikidot formatting.</option>
          <option value="fs3_combat" key="fs3_combat">FS3 Combat - Handles logs with FS3 skill or combat messages, omitting spam while keeping important combat messages.</option>
          <option value="fs3_combat_wiki" key="fs3_combat_wiki">FS3 Combat Wiki - Same as FS3 Combat, but also adds pretty wikidot formatting.</option>
          <option value="tgg_battle" key='tgg_battle'>TGG Battle - Handles battle logs from The Greatest Generation MUX, omitting spam while keeping important combat messages.</option>
          <option value="tgg_battle_wiki" key="tgg_battle_wiki">TGG Battle Wiki - Same as TGG Battle, but also adds pretty wikidot formatting.</option>
        </select>
      </div>
     
  
      <div className="form-field-group">    
        <label htmlFor="profile">Log Text:</label>
        <textarea
           id="log"
           name="log"
           rows={20}
           cols={100}
           onChange={formik.handleChange}
           value={formik.values.log}
        />
      </div> 
           
        <button type="submit" disabled={formik.isSubmitting}>
         Clean Log
        </button>

    </form>


     { completeMessage ?  <div className="note">{completeMessage}</div> : '' }
     
     { formattedLog ? 
        <>
         <h2>Formatted Log</h2>
         <textarea
         id="formattedLog"
         name="formattedLog"
         rows={20}
         cols={100}
         value={formattedLog}
         readOnly
         />
        </> : '' 
     }
      
    
   </>
  )
};

export default LogCleaner;


