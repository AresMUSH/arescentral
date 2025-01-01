import { useState, useEffect } from "react";
import { useNavigate, useLoaderData } from "react-router-dom";
import { Helmet } from "react-helmet-async";
import { getPlugin, PluginResponse, Plugin } from "../../services/ContribsService";
import { updatePlugin } from "../../services/AdminService";
import styles from './EditPlugin.module.scss'
import { useAuth } from '../../contexts/AuthContext';
import { useFormik } from "formik";
import { isErrorResponse } from "../../services/RequestHelper";
import type { ActionFunction } from "react-router";

export const loadPlugin : ActionFunction = async({params}) => {
  const data = await getPlugin(params.pluginId || '');
  return data;
}

const EditPlugin = () => {
  const { plugin } = useLoaderData() as PluginResponse;

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
      formik.setValues(plugin);
    }
  }, [user]);
  
  useEffect(() => {
    formik.setValues(plugin);
  }, [plugin]);
  
  
  const formik = useFormik<Plugin>({
    initialValues: {
      id: '',
      key: '',
      installs: 0,
      name: '',
      category: 'Other',
      web_portal: false,
      custom_code: false,
      description: '',
      author_name: '',
      url: '',
      games: []
    },

    onSubmit: (async (values) => {
      setCompleteMessage('');
      try {
        const response = await updatePlugin(plugin.id, values);
        if (isErrorResponse(response)) {
          setCompleteMessage(response.error);
        } else
        {
          setCompleteMessage('Plugin updated.');        
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
        <title>Edit Plugin - AresCentral</title>
      </Helmet>
      <h1>Edit Plugin</h1> 
      
      <form onSubmit={formik.handleSubmit}>

        <div className="form-field-group">   
          <label htmlFor="name">Name:</label>
          <input
             id="name"
             name="name"
             type="text"
             onChange={formik.handleChange}
             value={formik.values.name}
          />
        </div>

        <div className="form-field-group">   
          <label htmlFor="author_name">Author Name:</label>
          <input
             id="author_name"
             name="author_name"
             type="text"
             onChange={formik.handleChange}
             value={formik.values.author_name}
          />
        </div>

        <div className="form-field-group">   
          <label htmlFor="url">URL:</label>
          <input
             id="url"
             name="url"
             type="text"
             onChange={formik.handleChange}
             value={formik.values.url}
          />
        </div>

        <div className="form-field-group">   
          <label htmlFor="description">Description:</label>
          <input
             id="description"
             name="description"
             type="text"
             onChange={formik.handleChange}
             value={formik.values.description}
          />
        </div>
                                            
        <div className="form-field-group">    
          <label htmlFor="web_included">Web Portal Support:</label>
          <input 
             id="web_portal"
             name="web_portal" 
             type="checkbox" 
             onChange={formik.handleChange} 
             checked={formik.values.web_portal} 
          />
        </div>
        <div className="form-field-group">    
          <label htmlFor="custom_code">Custom Code:</label>
          <input 
             id="custom_code"
             name="custom_code" 
             type="checkbox" 
             onChange={formik.handleChange} 
             checked={formik.values.custom_code} 
          />
        </div>
        
         <div className="form-field-group">    
           <label htmlFor="category">Category:</label>
           <select 
              id="category"
              name="category" 
              onChange={formik.handleChange}
              value={formik.values.category} 
           >
            <option value="Skills" key="skills">Skills</option>
            <option value="System" key="system">System</option>
            <option value="RP" key="rp">RP</option>
            <option value="Community" key="community">Community</option>
            <option value="Building" key="building">Building</option>
            <option value="Other" key="other">Other</option>
           </select>
         </div>
        
        <button type="submit" disabled={formik.isSubmitting}>
         Save
        </button>
      </form>

      { completeMessage ? <p className={styles['admin-note']}><b>{completeMessage}</b></p> : '' }

    </>
  );
};

export default EditPlugin;