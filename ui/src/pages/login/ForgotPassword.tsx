import React, { useEffect, useState } from "react";
import { Helmet } from "react-helmet-async";
import { useNavigate, Link } from "react-router-dom";
//import styles from './ForgotPassword.module.scss'
import { useAuth } from '../../contexts/AuthContext';
import { useFormik, FormikErrors } from "formik";
import { forgotPassword } from "../../services/LoginService";

const ForgotPassword = () => {

  const [error, setError] = useState<React.ReactNode>("");
  const [resetComplete, setResetComplete] = useState<boolean>(false);
  const navigate = useNavigate();
  const { user } = useAuth();

  interface FormValues {
    name: string;
    email: string;
  }
  
  const formik = useFormik({
    initialValues: {
      email: '',
      name: ''
    },
    
    onSubmit: (async (values) => {
      try {
        await forgotPassword(values.name, values.email);
        setResetComplete(true);
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
      if (!values.email) {
        errors.email = 'Email is required.';
      }          
      return errors;
      return errors;
    },
    validateOnChange: false,
  });
  

  useEffect(() => {
    const validationError = formik.errors.name || formik.errors.email;
    setError(validationError);
  }, [formik.errors]);
    
  useEffect(() => {
    if (user) {
      navigate('/');
    }
  }, []);
  
  return (
    <>
      <Helmet>
        <title>Forgot Password - AresCentral</title>
      </Helmet>
    {
      resetComplete ? 
        <div className="note">
          <p>If that email is in our records, a new password will be sent to it. Once you receive it, try to <Link to="/login">log in</Link> again.</p>
      
          <p>If you don't receive an email, <a href="https://aresmush.com/feedback.html" target="_blank" rel="noopener">contact Faraday</a> for help.</p>
      
        </div>
       : <>
       <p>Please enter the handle name and email you associated with your handle. 
      If you didn't set an email or don't remember it, <a href="https://aresmush.com/feedback.html" target="_blank" rel="noopener">contact Faraday</a> for help.
       </p>
   
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
             <label htmlFor="name">Email:</label>
             <input
                id="email"
                name="email"
                type="text"
                onChange={formik.handleChange}
                value={formik.values.email}
             />
           </div>
              
              {
                error ? <div className="warning">{error}</div> : ''
              }
           <button type="submit" disabled={formik.isSubmitting}>
            Submit
           </button>
        </form>  
              </>      
      
    }

             
    </>
  );
}

export default ForgotPassword;