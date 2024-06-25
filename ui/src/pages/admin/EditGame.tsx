import { useState, useEffect } from "react";
import { useNavigate, useLoaderData } from "react-router-dom";
import { Helmet } from "react-helmet-async";
import { getGame, GameResponse, Plugin } from "../../services/GamesService";
import { updateGameStatus } from "../../services/AdminService";
//import styles from './EditGame.module.scss'
import { useAuth } from '../../contexts/AuthContext';
import { useFormik } from "formik";
import { isErrorResponse } from "../../services/RequestHelper";
import type { ActionFunction } from "react-router";

const EditGame = () => {
  const { game } = useLoaderData() as GameResponse;

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
    else if (user != null && !user.is_admin) {
      navigate('/NotFound');      
    }
    else {
      formik.setValues(game);
    }
  }, [user]);  

  useEffect(() => {
    if (game) {
      formik.setFieldValue('status', game.status);
      formik.setFieldValue('is_public', game.public_game);
      formik.setFieldValue('wiki_archive', game.wiki_archive);
    }
  }, [game]);
  
  const formik = useFormik({
    initialValues: {
      status: '',
      is_public: false,
      wiki_archive: ''
    },

    onSubmit: (async (values) => {
      setCompleteMessage('');
      try {
        const response = await updateGameStatus(game.id, values.status, values.is_public, values.wiki_archive);
        if (isErrorResponse(response)) {
          setCompleteMessage(response.error);
        } else
        {
          setCompleteMessage('Game updated.');        
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
        <title>Edit Game - AresCentral</title>
      </Helmet>
      <h1>Edit {game.name}</h1> 
      

      
     <form onSubmit={formik.handleSubmit}>
    
    

        <div className="form-field-group">    
          <label htmlFor="is_public">Is Public:</label>
          <input 
             id="is_public"
             name="is_public" 
             type="checkbox" 
             onChange={formik.handleChange} 
             checked={formik.values.is_public} 
          />
        </div>
       
        <div className="form-field-group">    
          <label htmlFor="status">Status:</label>
          <select 
             id="status"
             name="status" 
             onChange={formik.handleChange}
             value={formik.values.status} 
          >
           <option value="In Development" key="dev">In Dev</option>
           <option value="Alpha" key="alpha">Alpha</option>
           <option value="Beta" key="beta">Beta</option>
           <option value="Open" key="open">Open</option>
           <option value="Closed" key="closed">Closed</option>
           <option value="Sandbox" key="sandbox">Sandbox</option>
          </select>
        </div>
             
        <div className="form-field-group">   
          <label htmlFor="name">Wiki Archive:</label>
          <input
             id="wiki_archive"
             name="wiki_archive"
             type="text"
             onChange={formik.handleChange}
             value={formik.values.wiki_archive}
          />
        </div>
       
       <button type="submit" disabled={formik.isSubmitting}>
        Update
       </button>
     </form>

     { completeMessage ? <p className="note"><b>{completeMessage}</b></p> : '' }
    

    </>
  );
};

export default EditGame;