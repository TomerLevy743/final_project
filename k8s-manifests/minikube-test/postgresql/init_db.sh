    #!/bin/bash
    # init_db.sh

    # Create the statuspage role if it doesn't exist
    psql -U admin_statuspage -d db_statuspage << EOF
    DO \$\$ 
    BEGIN 
        IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'statuspage') THEN
            CREATE ROLE statuspage LOGIN PASSWORD '0123456789';
        END IF;
    END
    \$\$;

    GRANT ALL PRIVILEGES ON DATABASE db_statuspage TO statuspage;
    GRANT ALL PRIVILEGES ON SCHEMA public TO statuspage;
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO statuspage;
    EOF
