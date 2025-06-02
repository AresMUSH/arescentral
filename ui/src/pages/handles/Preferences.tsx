import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { Helmet } from "react-helmet-async";
//import styles from './Preferences.module.scss'
import { useAuth } from '../../contexts/AuthContext';
import { useFormik, FormikErrors } from "formik";
import { getPreferences, savePreferences } from "../../services/HandlesService";
import { isErrorResponse } from "../../services/RequestHelper";

const Preferences = () => {
  const [timezones, setTimezones] = useState<string[]>([]);
  const [error, setError] = useState<React.ReactNode>("");
  const [completeMessage, setCompleteMessage] = useState<boolean>(false);
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
          const response = await getPreferences();
          setTimezones(response.timezones);
          formik.setValues(response.preferences);
        } catch(e : any) {
          console.log(e);
          navigate('/error');
        }
      }
      fetchData();
    }
  }, [user]);
  
  interface FormValues {
    email: string;
    security_question: string;
    pose_autospace: string;
    pose_quote_color: string;
    page_autospace: string;
    page_color: string;
    ascii_only: boolean;
    screen_reader: boolean;
    timezone: string;
    profile_image: string;
    profile: string;
  }
  
  const formik = useFormik({
    initialValues: {
      email: '',
      security_question: '',
      pose_autospace: '',
      pose_quote_color: '',
      page_autospace: '',
      page_color: '',
      ascii_only: false,
      screen_reader: false,
      timezone: 'America/New_York',
      profile_image: '',
      profile: ''
    },
    
    onSubmit: (async (values) => {
      try {
        setCompleteMessage(false);
        const response = await savePreferences(values);
        if (isErrorResponse(response)) {
          setError(response.error);
        }
        else {
          setCompleteMessage(true);
        }
      } catch(e : any) {
        console.log(e);
        navigate('/error');
      }
    }),
    validate: values => {
      const errors : FormikErrors<FormValues> = {};
      if (!values.security_question) {
        errors.security_question = 'Favorite MU security question is required.';
      }       
    },
    validateOnChange: false,
  });
  

  useEffect(() => {
    const validationError = formik.errors.security_question;
    setError(validationError);
  }, [formik.errors]);

  return (
    <>
      <Helmet>
        <title>Preferences - AresCentral</title>
      </Helmet>
      
      <h1>Preferences</h1>
      
      <p>Set your player handle preferences.</p>
      
      {
        completeMessage ? <div className="note">Profile saved!</div> : ''
      }
      <form onSubmit={formik.handleSubmit}>
    
        <div className="form-section">
          <div className="form-section-header">Account Information</div>

          <div className="form-section-body">               
    
            <div className="form-field-group">   
              <label htmlFor="email">Email (optional):</label>
              <input
                 id="email"
                 name="email"
                 type="text"
                 onChange={formik.handleChange}
                 value={formik.values.email}
              />
            </div>

            <div className="note">
              Email is optional, but if you provide one you can use it to reset your password automatically. View the <a href="https://aresmush.com/privacy.html" target="_blank" rel="noopener">Privacy Policy</a> to see how your data is protected.
            </div>
               
            <div className="form-field-group">    
              <label htmlFor="security_question">What was your most memorable MU*?:</label>
              <input
                 id="security_question"
                 name="security_question"
                 type="text"
                 onChange={formik.handleChange}
                 value={formik.values.security_question}
              />
            </div>

            <div className="note">
              Memorable MU* is used as a security question in case you ever get locked out of your account.
            </div>
           </div>
        </div>

        <div className="form-section">
          <div className="form-section-header">Character Preferences</div>

          <div className="form-section-body">               
            <p>
              You can set these preferences once here on AresCentral and they will carry over to all of your linked characters.
            </p>
               
            <div className="form-field-group">    
              <label htmlFor="pose_autospace">Pose Autospace:</label>
              <input
                 id="pose_autospace"
                 name="pose_autospace"
                 type="text"
                 onChange={formik.handleChange}
                 value={formik.values.pose_autospace}
              />
            </div>
               
            <div className="form-field-group">    
              <label htmlFor="pose_quote_color">Pose Quote Color:</label>
              <input
                 id="pose_quote_color"
                 name="pose_quote_color"
                 type="text"
                 onChange={formik.handleChange}
                 value={formik.values.pose_quote_color}
              />
            </div>
                
            <div className="form-field-group">    
              <label htmlFor="page_autospace">OOC/Page Autospace:</label>
              <input
                 id="page_autospace"
                 name="page_autospace"
                 type="text"
                 onChange={formik.handleChange}
                 value={formik.values.page_autospace}
              />
            </div>

            <div className="form-field-group">    
              <label htmlFor="page_color">Page Color:</label>
              <input
                 id="page_color"
                 name="page_color"
                 type="text"
                 onChange={formik.handleChange}
                 value={formik.values.page_color}
              />
            </div>               

            <div className="form-field-group">    
              <label htmlFor="ascii_only">ASCII-Only Client:</label>
              <input 
                 id="ascii_only"
                 name="ascii_only" 
                 type="checkbox" 
                 onChange={formik.handleChange} 
                 checked={formik.values.ascii_only} 
              />
            </div>
               
            <div className="form-field-group">    
              <label htmlFor="screen_reader">Screen Reader:</label>
              <input 
                 id="screen_reader"
                 name="screen_reader" 
                 type="checkbox" 
                 onChange={formik.handleChange} 
                 checked={formik.values.screen_reader} 
              />
            </div>
                 
            <div className="form-field-group">    
              <label htmlFor="timezone">Timezone:</label>
              <select 
                 id="timezone"
                 name="timezone" 
                 onChange={formik.handleChange}
                 value={formik.values.timezone} 
              >
               { 
                 timezones.map( tz => <option value={tz} key={tz}>{tz}</option> )                        
               }
              </select>

            </div>
                                  
                 
          </div>
        </div>

        <div className="form-section">
          <div className="form-section-header">Profile</div>

          <div className="form-section-body">               
    
            <p>This information is used in your handle profile. Keep it clean - offensive content will be removed.</p>

            <div className="form-field-group">   
              <label htmlFor="profile_image">Image URL:</label>
              <input
                 id="profile_image"
                 name="profile_image"
                 type="text"
                 onChange={formik.handleChange}
                 value={formik.values.profile_image}
              />
            </div>

               
            <div className="form-field-group">    
              <label htmlFor="profile">Profile Text (may contain markdown):</label>
              <textarea
                 id="profile"
                 name="profile"
                 rows={20}
                 cols={100}
                 onChange={formik.handleChange}
                 value={formik.values.profile}
              />
            </div>            
           </div>
        </div>
                                                              
             {
               error ? <div className="warning">{error}</div> : ''
             }
             {
               completeMessage ? <div className="note">Profile saved!</div> : ''
             }
          <button type="submit" disabled={formik.isSubmitting}>
           Save
          </button>
       </form>
             

    </>
  );
}

export default Preferences;