import React, { useEffect, useState } from "react";
import { useNavigate, Link } from "react-router-dom";
import { Helmet } from "react-helmet-async";
import styles from './Friends.module.scss'
import { useAuth } from '../../contexts/AuthContext';
import { HandleLinkedCharList } from "../../components/HandleLinkedCharList";
import { Handle, Friendship, addFriend, removeFriend, getFriends } from "../../services/HandlesService";
import { useFormik, FormikErrors } from "formik";
import { isErrorResponse } from "../../services/RequestHelper";

const Friends = () => {

  const [error, setError] = useState<React.ReactNode>("");
  const [allHandles, setAllHandles] = useState<Handle[]>([]);
  const [friends, setFriends] = useState<Friendship[]>([]);
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
    else {
      const fetchData = async () => {
        try {
          const response = await getFriends();
          if (isErrorResponse(response)) {
            setError(response.error);
          } else {
            setAllHandles(response.handles);
            setFriends(response.friends);
          }
        } catch(e : any) {
          console.log(e);
          navigate('/error');
        }
        
      }
      fetchData();
    }
  }, [user]);
  
  const onRemoveFriend = async (friend : Friendship) => {
    try {
      setCompleteMessage("");
      const response = await removeFriend(friend.id);
      if (isErrorResponse(response)) {
        setError(response.error);
      } else {
        setCompleteMessage("Friend removed.");
        setFriends(response.friends);
      }
    } catch(e : any) {
      console.log(e);
      navigate('/error');
    }
  }
 
  interface FormValues {
    name: string;
  }
  
  const formik = useFormik({
    initialValues: {
      name: ''
    },
    onSubmit: (async (values) => {
      try {
        setCompleteMessage("");
        const friend = allHandles.find((h : Handle) => h.name.toLowerCase() === values.name.toLowerCase());
        if (!friend) {
          setError("Handle not found.");
          return;
        }  
        const response = await addFriend(friend.id);
        if (isErrorResponse(response)) {
          setError(response.error);
        } else {
          setCompleteMessage("Friend added.");
          setFriends(response.friends);
          formik.resetForm();
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
            
      return errors;
    },
    validateOnChange: false,
  });
  

  useEffect(() => {
    const validationError = formik.errors.name;
    setError(validationError);
  }, [formik.errors]);
  
  
  return (
    <>
      <Helmet>
        <title>Friends - AresCentral</title>
      </Helmet>
      
      <h1>Friends</h1>
    
      <p>When you add a player as a friend, you can see if they have characters on the same games you do.</p>
      
    {
        friends.map(friend => 
          <div className={styles['friend-entry']} key={friend.id}>
            <h2>{friend.name}</h2>
          
            <HandleLinkedCharList links={friend.games} />

            <div className={styles['friend-actions']}>
              <Link to={`/handle/${friend.name}`}><button>Profile <i className="fa fa-eye" /></button></Link>          
              <button className="warn" onClick={() => onRemoveFriend(friend)}>Unfriend <i className="fa fa-ban" /></button>
            </div>
          </div>
  
        )
        
      }
      
      <h2>Add Friend</h2>

      <p>Add a new friend by specifying their handle name.</p>
      
      
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

          <button type="submit" disabled={formik.isSubmitting}>
           Submit
          </button>
               
           {
             error ? <div className="warning">{error}</div> : ''
           }
  
           {
             completeMessage ? <div className="note">{completeMessage}</div> : ''
           }
       </form>
       
      
    </>
  );
}

export default Friends;