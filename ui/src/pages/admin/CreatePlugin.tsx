import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { Helmet } from "react-helmet-async";
import { createPlugin } from "../../services/AdminService";
import { Plugin } from "../../services/ContribsService";
import styles from './CreatePlugin.module.scss'
import { useAuth } from '../../contexts/AuthContext';
import { useFormik } from "formik";
import { isErrorResponse } from "../../services/RequestHelper";

const CreatePlugin = () => {

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
    else if (user && !user.is_admin) {
      navigate('/NotFound');      
    }
  }, [user]);
  
  
  const formik = useFormik<Plugin>({
    initialValues: {
      name: '',
      category: 'Other',
      web_portal: false,
      custom_code: false,
      description: '',
      author_name: '',
      url: '',
      installs: 0,
      id: '',
      key: ''
    },

    onSubmit: (async (values) => {
      setCompleteMessage('');
      try {
        const response = await createPlugin(values);
        if (isErrorResponse(response)) {
          setCompleteMessage(response.error);
        } else
        {
          setCompleteMessage('Plugin created.');        
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
        <title>Create Plugin - AresCentral</title>
      </Helmet>
      <h1>Create Plugin</h1> 
      
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
         Create
        </button>
      </form>

      { completeMessage ? <p className={styles['admin-note']}><b>{completeMessage}</b></p> : '' }

    </>
  );
};

export default CreatePlugin;