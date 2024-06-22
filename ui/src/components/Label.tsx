import styles from "./Label.module.scss";


interface LabelProps {
  className?: string,
  children: React.ReactNode,
  status: string
}

export const Label = ( { children, className, status }: LabelProps ) => {

  return (
    <span className={`${styles['label']} ${styles[status]} ${className}`}>
      {children}
    </span>
  );
}

export default Label;


    