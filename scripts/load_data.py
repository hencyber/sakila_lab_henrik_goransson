"""
Script för att ladda Sakila SQLite-databas till DuckDB.

Detta script gör följande:
1. Kontrollerar att SQLite-databasen finns
2. Laddar alla tabeller från SQLite till DuckDB
3. Verifierar att migreringen fungerade korrekt

LÄRANDE KONCEPT:
- Context managers (with-satsen) för automatisk resurshantering
- DuckDB:s SQLite-integration
- Hur man migrerar data mellan databaser
"""

import duckdb
import sqlite3
from pathlib import Path


# SÖKVÄGAR - Definiera var våra filer finns

BASE_DIR = Path(__file__).parent.parent  # Projektets rotkatalog
DATA_DIR = BASE_DIR / "data"              # data/-mappen
SQLITE_DB_PATH = DATA_DIR / "sakila.db"   # SQLite-databasen
DUCKDB_PATH = DATA_DIR / "sakila.duckdb"  # DuckDB-databasen (skapas)

def verify_sqlite_database():
    """
    Verifiera att SQLite-databasen existerar och är giltig.
    
    Returns:
        list: Lista med tabellnamn i databasen
        
    Raises:
        FileNotFoundError: Om databasen inte finns
    """
    # Kolla om filen finns
    if not SQLITE_DB_PATH.exists():
        raise FileNotFoundError(
            f"ERROR: SQLite-databasen hittades inte på {SQLITE_DB_PATH}\n\n"
            "Ladda ner Sakila SQLite-databas från:\n"
            "https://www.kaggle.com/datasets/atanaskanev/sqlite-sakila-sample-database\n\n"
            "Instruktioner:\n"
            "1. Skapa ett gratis Kaggle-konto om du inte har ett\n"
            "2. Ladda ner och packa upp ZIP-filen\n"
            "3. Byt namn på 'sakila_master.db' till 'sakila.db'\n"
            "4. Placera filen i data/-mappen"
        )
    
    
    # CONTEXT MANAGER för SQLite-anslutning

    # 'with' ser till att anslutningen stängs automatiskt
    # även om något går fel = bra practice!
    with sqlite3.connect(SQLITE_DB_PATH) as conn:
        cursor = conn.cursor()
        # Hämta alla tabeller från SQLite
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
        tables_raw = cursor.fetchall()
    # När vi lämnar 'with'-blocket stängs anslutningen automatiskt!
    
    tables = [table[0] for table in tables_raw]
    print("Hittade SQLite-databas med", len(tables), "tabeller")
    print("Tabeller:", ", ".join(tables))
    print()
    
    return tables


def load_sqlite_to_duckdb():
    """
    ================================================
    HUVUDFUNKTION: Migrera data från SQLite till DuckDB
    ================================================
    
    Denna funktion:
    1. Verifierar att SQLite-databasen finns
    2. Skapar en ny DuckDB-databas
    3. Installerar SQLite-extension i DuckDB
    4. Kopierar alla tabeller från SQLite till DuckDB
    5. Verifierar att all data har kopierats korrekt
    """
    
    # Steg 1: Verifiera SQLite-databasen
    print("=" * 60)
    print("STEG 1: Verifierar SQLite-databas...")
    print("=" * 60)
    tables = verify_sqlite_database()
    
    # Steg 2: Skapa DuckDB-anslutning och installera SQLite-extension
    print("=" * 60)
    print("STEG 2: Förbereder DuckDB...")
    print("=" * 60)
    print("Installerar SQLite-extension...")
    
    with duckdb.connect(str(DUCKDB_PATH)) as conn:
        
        # Steg 2a: Installera och ladda SQLite-extension
        # Detta gör att DuckDB kan läsa SQLite-filer direkt
        conn.sql("INSTALL sqlite;")
        conn.sql("LOAD sqlite;")
        print("SQLite-extension installerad och laddad")
        
        # Steg 3: Anslut SQLite-databasen
        print()
        print("=" * 60)
        print("STEG 3: Ansluter till SQLite-databas...")
        print("=" * 60)
        
        # Använd ATTACH för att göra SQLite-databasen tillgänglig i DuckDB
        # Vi ger den alias 'sqlite_db' så vi kan referera till den
        attach_query = f"ATTACH '{SQLITE_DB_PATH}' AS sqlite_db (TYPE sqlite);"
        conn.sql(attach_query)
        print("SQLite-databas ansluten som 'sqlite_db'")
        
        # Steg 4: Kopiera alla tabeller
        print()
        print("=" * 60)
        print("STEG 4: Kopierar tabeller från SQLite till DuckDB...")
        print("=" * 60)
        
        for table in tables:
            print(f"  Kopierar tabell: {table}")
            
            # CREATE OR REPLACE TABLE = skapa tabell (ersätt om den finns)
            # AS SELECT * FROM = kopiera all data
            copy_query = f"CREATE OR REPLACE TABLE {table} AS SELECT * FROM sqlite_db.{table};"
            conn.sql(copy_query)
        
        print("Alla tabeller kopierade")
        
        # Steg 5: Verifiera att data har kopierats korrekt
        print()
        print("=" * 60)
        print("STEG 5: Verifierar datamigrering...")
        print("=" * 60)
        
        for table in tables:
            # Räkna antal rader i varje tabell
            count_query = f"SELECT COUNT(*) FROM {table};"
            row_count = conn.sql(count_query).fetchone()[0]
            print(f"  {table}: {row_count} rader")
    
    # Steg 6: Klart!
    print()
    print("=" * 60)
    print("DATAMIGRERING KLAR!")
    print("=" * 60)
    print(f"DuckDB-databas skapad: {DUCKDB_PATH}")
    print()
    print("Nästa steg:")
    print("   - Öppna Jupyter Notebook: uv run jupyter notebook")
    print("   - Kör notebook: notebooks/sakila_analysis.ipynb")


if __name__ == "__main__":
    """
    Huvudprogram - körs när scriptet körs direkt
    """
    # Skapa data/-mappen om den inte finns
    DATA_DIR.mkdir(exist_ok=True)
    
    try:
        # Kör migreringen
        load_sqlite_to_duckdb()
        
        # Visa framgångsmeddelande
        print("\n" + "="*60)
        print("KLAR!")
        print("="*60)
        print("\nNästa steg: Öppna Jupyter notebook:")
        print("   uv run jupyter notebook notebooks/sakila_analysis.ipynb")
        
    except FileNotFoundError as e:
        # Fånga felet om databasen saknas
        print(f"\n{e}")
        exit(1)
        
    except Exception as e:
        # Fånga alla andra ovänta fel
        print(f"\nERROR: Oväntat fel: {e}")
        print("\nTips: Kontrollera att du har rätt beroenden installerade:")
        print("   uv sync")
        exit(1)

