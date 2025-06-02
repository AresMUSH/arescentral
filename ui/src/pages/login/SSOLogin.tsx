import React, { useEffect, useState } from "react";
import { useNavigate, useLocation } from "react-router-dom";
import { Helmet } from "react-helmet-async";
//import styles from './SSOLogin.module.scss'
import { ssoLogin } from '../../services/LoginService';
import { useFormik, FormikErrors} from "formik";
import { isErrorResponse } from "../../services/RequestHelper";

const SSOLogin = () => {

  const [error, setError] = useState<React.ReactNode>("");
  const navigate = useNavigate();
  const loc = useLocation();

  interface FormValues {
    name: string;
    password: string;
  }

  const formik = useFormik({
    initialValues: {
      name: '', 
      password: ''
    },
    onSubmit: (async (values) => {
      try {        
        const queryParams = loc.search.substring(1, loc.search.length);
        const response = await ssoLogin(values.name, values.password, queryParams);
        if (isErrorResponse(response)) {
          setError(response.error);
        }
        else {
          window.location.replace(response.redirect_url);
        }
      } catch(e : any) {
        console.log(e);
        navigate('/error');
      }        
    }),
    validate: values => {
      const errors : FormikErrors<FormValues> = {};
      if (!values.name) {
        errors.name = 'Handle name is required.';
      } 
      if (!values.password) {
        errors.password = 'Password is required.';
      }          
      return errors;
    },
    validateOnChange: false,
  });
  

  useEffect(() => {
    const validationError = formik.errors.name || formik.errors.password;
    setError(validationError);
  }, [formik.errors]);

  return (
    <>
      <Helmet>
        <title>Forum Login - AresCentral</title>
      </Helmet>
      
      <p>Log in using your AresMUSH Player Handle.</p>
    
      <form onSubmit={formik.handleSubmit}>
          <div className="form-field-group">   
            <label htmlFor="name">Handle:</label>
            <input
               id="name"
               name="name"
               type="text"
               onChange={formik.handleChange}
               value={formik.values.name}
            />
          </div>

          <div className="form-field-group">    
            <label htmlFor="password">Password:</label>
            <input
               id="password"
               name="password"
               type="password"
               onChange={formik.handleChange}
               value={formik.values.password}
            />
          </div>
               
             {
               error ? <div className="warning">{error}</div> : ''
             }
          <button type="submit" disabled={formik.isSubmitting}>
           Submit
          </button>
       </form>
             
      <p>Need help or don't have an account? Visit <a href="https://arescentral.aresmush.com">AresCentral</a>.</p>
    </>
  );
}

export default SSOLogin;