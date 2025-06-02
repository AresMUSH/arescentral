import React, { useEffect, useState, useRef } from "react";
import { useNavigate, Link } from "react-router-dom";
import { Helmet } from "react-helmet-async";
import styles from './Register.module.scss'
import { useAuth } from '../../contexts/AuthContext';
import { useFormik, FormikErrors } from "formik";
import { Turnstile, TurnstileInstance } from '@marsidev/react-turnstile'


const Register = () => {

  const [error, setError] = useState<React.ReactNode>("");
  const [token, setToken] = useState<string>("");
  const navigate = useNavigate();
  const { user, register } = useAuth();
  const turnstileWidget = useRef<TurnstileInstance|null>(null);

  useEffect(() => {
    if (user) {
      navigate('/');
    }
  }, [user]);

  interface FormValues {
    name: string;
    password: string;
    email: string;
    securityQuestion: string;
    isHuman: boolean;
  }

  const formik = useFormik({
    initialValues: {
      name: '', 
      password: '',
      email: '',
      securityQuestion: '',
      isHuman: false
    },
    
    onSubmit: (async (values) => {
      
      if (!token || token.length === 0) {
        setError("There was a problem reading the captcha token. Please reload the page.");
        return;
      }
      
      if (values.isHuman) {
        navigate("/");
        return;
      }
      try {
        const error = await register(values.name, 
          values.password, 
          values.email, 
          values.securityQuestion,
          token)

        if (error) {
          turnstileWidget.current?.reset();
          
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
      if (!values.securityQuestion) {
        errors.password = 'Security question (most memorable MU) is required.';
      }          
      return errors;
    },
    validateOnChange: false,
  });
  

  useEffect(() => {
    const validationError = formik.errors.name || 
      formik.errors.password ||
      formik.errors.securityQuestion;
    setError(validationError);
  }, [formik.errors]);

  return (
    <>
      <Helmet>
        <title>Register - AresCentral</title>
    
    
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.2.1/css/bootstrap.min.css" integrity="sha512-siwe/oXMhSjGCwLn+scraPOWrJxHlUgMBMZXdPe2Tnk3I0x3ESCoLz7WZ5NTH6SZrywMY+PB1cjyqJ5jAluCOg==" crossOrigin="anonymous" referrerPolicy="no-referrer" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.9.1/font/bootstrap-icons.min.css" integrity="sha512-5PV92qsds/16vyYIJo3T/As4m2d8b6oWYfoqV+vtizRB6KhF1F9kYzWzQmsO6T3z3QG2Xdhrx7FQ+5R1LiQdUA==" crossOrigin="anonymous" referrerPolicy="no-referrer" />
    
    
      </Helmet>
      <h1>Register</h1>
      <form onSubmit={formik.handleSubmit}>
          <div className="form-field-group">   
            <label htmlFor="name">Handle Name:</label>
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

          <div className="form-field-group">   
            <label htmlFor="securityQuestion">What was your most memorable MU*?:</label>
            <input
               id="securityQuestion"
               name="securityQuestion"
               type="text"
               onChange={formik.handleChange}
               value={formik.values.securityQuestion}
            />
             
          </div>

          <div className="note">
           Memorable MU* is used as a security question in case you ever get locked out of your account.
          </div>

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


             
           <div className={styles['confirm-human-field']}>
            <input type="checkbox" 
             name="isHuman"
             className={styles['confirm-human-field']}
             onChange={formik.handleChange} 
             checked={formik.values.isHuman} 
             aria-label="Humans, please leave this box UNchecked." />
            I am not a robot, I swear
           </div>
           
           {
             error ? <div className="warning">{error}</div> : ''
           }

           <Turnstile 
             ref={turnstileWidget} 
             siteKey={import.meta.env.VITE_ARESCENTRAL_TURNSTILE_ID} 
             onSuccess={setToken} 
            />
                   
                       
          <button type="submit" disabled={formik.isSubmitting} >
           Submit
          </button>
       </form>
             
       <p>Already have a handle? <Link to="/login">Log in.</Link></p>

         
      
    </>
  );
}

export default Register;