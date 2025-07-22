import { css } from '@emotion/css';
import { GrafanaTheme2 } from '@grafana/data';
import { useStyles2 } from '@grafana/ui';

// ✅ Ruta sin "/public", ya que todo lo que esté en public se sirve desde la raíz del dominio
const helpOptions = [
  {
    value: 0,
    label: 'Documentación',
    href: '/img/Documentacion_Cliente_Agroptimumm.pdf',
  },
  {
    value: 1,
    label: 'Tutoriales',
    href: 'https://www.youtube.com/watch?v=JRtUDZGwp0Y',
  },
  {
    value: 2,
    label: 'Comunidad',
    href: 'https://agroptimum.com/',
  },
];

export const WelcomeBanner = () => {
  const styles = useStyles2(getStyles);

  return (
    <div className={styles.container}>
      <h1 className={styles.title}>Bienvenido a Sensórica Agróptimum</h1>
      <div className={styles.help}>
        <h3 className={styles.helpText}>¿Necesitas ayuda?</h3>
        <div className={styles.helpLinks}>
          {helpOptions.map((option, index) => (
            <a
              key={`${option.label}-${index}`}
              className={styles.helpLink}
              href={option.href}
              target="_blank"
              rel="noopener noreferrer"
            >
              {option.label}
            </a>
          ))}
        </div>
      </div>
    </div>
  );
};

const getStyles = (theme: GrafanaTheme2) => {
  return {
    container: css({
      display: 'flex',
      backgroundSize: 'cover',
      height: '100%',
      alignItems: 'center',
      justifyContent: 'space-between',
      padding: theme.spacing(0, 3),

      [theme.breakpoints.down('lg')]: {
        backgroundPosition: '0px',
        flexDirection: 'column',
        alignItems: 'flex-start',
        justifyContent: 'center',
      },

      [theme.breakpoints.down('sm')]: {
        padding: theme.spacing(0, 1),
      },
    }),
    title: css({
      marginBottom: 0,
      fontWeight: 600,

      [theme.breakpoints.down('lg')]: {
        marginBottom: theme.spacing(1),
      },

      [theme.breakpoints.down('md')]: {
        fontSize: theme.typography.h2.fontSize,
      },
      [theme.breakpoints.down('sm')]: {
        fontSize: theme.typography.h3.fontSize,
      },
    }),
    help: css({
      display: 'flex',
      alignItems: 'baseline',
    }),
    helpText: css({
      marginRight: theme.spacing(2),
      marginBottom: 0,

      [theme.breakpoints.down('md')]: {
        fontSize: theme.typography.h4.fontSize,
      },

      [theme.breakpoints.down('sm')]: {
        display: 'none',
      },
    }),
    helpLinks: css({
      display: 'flex',
      flexWrap: 'wrap',
    }),
    helpLink: css({
      marginRight: theme.spacing(2),
      textDecoration: 'underline',
      whiteSpace: 'nowrap',

      [theme.breakpoints.down('sm')]: {
        marginRight: theme.spacing(1),
      },
    }),
  };
};
