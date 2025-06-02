import React, { useEffect, useState } from "react";
import { useNavigate, Link } from "react-router-dom";
import { Helmet } from "react-helmet-async";
//import styles from './ChangePassword.module.scss'
import { useAuth } from '../../contexts/AuthContext';
import { changePassword } from "../../services/LoginService";
import { useFormik, FormikErrors } from "formik";
import { isErrorResponse } from "../../services/RequestHelper";

const ChangePassword = () => {

  const [error, setError] = useState<React.ReactNode>("");
  const [resetComplete, setResetComplete] = useState<boolean>(false);
  const navigate = useNavigate();
  const { user } = useAuth();

  interface FormValues {
    oldPassword: string;
    newPassword: string;
  }
  
  const formik = useFormik({
    initialValues: {
      oldPassword: '', 
      newPassword: ''
    },
    onSubmit: (async (values) => {
      try {
        const response = await changePassword(values.oldPassword, values.newPassword);
        if (isErrorResponse(response)) {
          setError(response.error);
        }
        else {
          setResetComplete(true);
        }
      } catch(e : any) {
        console.log(e);
        navigate('/error');
      }
    }),
    validate: values => {
      const errors : FormikErrors<FormValues> = {};
      if (!values.oldPassword) {
        errors.oldPassword = 'Old password is required.';
      } 
      if (!values.newPassword) {
        errors.newPassword = 'New password is required.';
      }          
      return errors;
    },
    validateOnChange: false,
  });
  

  useEffect(() => {
    const validationError = formik.errors.oldPassword || formik.errors.newPassword;
    setError(validationError);
  }, [formik.errors]);

  useEffect(() => {
    // Check for null - undefined means not loaded yet.
    if (user === null) {
      navigate('/');
    }
  }, [user]);
  
  return (
    <>
      <Helmet>
        <title>Change Password - AresCentral</title>
      </Helmet>
      <h1>Change Password</h1>
      
    {
      resetComplete ? <div className="note">
        <p>Password reset!</p> 
      </div> : <>
        <p>Change your password.</p>
    
        <form onSubmit={formik.handleSubmit}>
            <div className="form-field-group">   
              <label htmlFor="oldPassword">Old Password:</label>
              <input
                 id="oldPassword"
                 name="oldPassword"
                 type="password"
                 onChange={formik.handleChange}
                 value={formik.values.oldPassword}
              />
            </div>

            <div className="form-field-group">    
              <label htmlFor="password">New Password:</label>
              <input
                 id="newPassword"
                 name="newPassword"
                 type="password"
                 onChange={formik.handleChange}
                 value={formik.values.newPassword}
              />
            </div>
               
               {
                 error ? <div className="warning">{error}</div> : ''
               }
            <button type="submit" disabled={formik.isSubmitting}>
             Submit
            </button>
         </form>
             
        <p>Forgot your password? <Link to="/forgot-password">Reset it.</Link></p>
       </>
     }
    </>
  );
}

export default ChangePassword;