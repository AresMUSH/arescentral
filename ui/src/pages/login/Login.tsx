import React, { useEffect, useState } from "react";
import { useNavigate, Link } from "react-router-dom";
import { Helmet } from "react-helmet-async";
//import styles from './Login.module.scss'
import { useAuth } from '../../contexts/AuthContext';
import { useFormik, FormikErrors } from "formik";

const Login = () => {

  const [error, setError] = useState<React.ReactNode>("");
  const navigate = useNavigate();
  const { login, user } = useAuth();

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
        const error = await login(values.name, values.password);
        if (error) {
          setError(error);
        }
        else {
          navigate("/");
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

  useEffect(() => {
    if (user) {
      navigate('/');
    }
  }, [user]);
  
  return (
    <>
      <Helmet>
        <title>Login - AresCentral</title>
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
             
      <p>Don't have a handle? <Link to="/register">Create one.</Link></p>
      <p>Forgot your password? <Link to="/forgot-password">Reset it.</Link></p>
    </>
  );
}

export default Login;