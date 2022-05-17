#!/usr/bin/python3
import csv
from datetime import date, timedelta,datetime
import random 
import faker
import sys
# GLOBAL VARIABLES USED DURING EXECUTION TO HAUL ALL DATA THAT WILL BE PRINTED INTO A FILE
OEUVRELS:"list[Oeuvre]"=[]
ARTISTELS:"list[Artiste]"=[]
PRODUCTEURLS:"list[ProducteurStudio]"=[]
CONTRATLS:"list[Contrat]"=[]
AGENTLS:"list[Agent]"=[]
GESTIONLS:"list[Gestion]"=[]

# DATA CLASSES WITH CSV CONVERSION




class Agent():
    fakegen = faker.Faker('fr-FR')
    id=1
    @classmethod
    def nextid(cls):
        toret=cls.id
        cls.id =cls.id+1
        return toret 

    def __init__(self,
        nom,
        prenom,
        adresse,
        date_naissance:date,
        genre,
        mail,
        numero_telephone):
        """builder of class Agent"""
        self.id=Agent.nextid()
        self.nom=nom
        self.prenom=prenom
        self.adresse=adresse
        self.date_naissance=date_naissance
        self.genre=genre
        self.mail=mail
        self.numero_telephone=numero_telephone

    @classmethod
    def generate(cls,datedeb:date,datefin:date):
        nm= Agent.fakegen.last_name()
        prnm= Agent.fakegen.first_name()
        adr= Agent.fakegen.address().replace('\n','')
        dn = None
        while True :
            dn:date=Agent.fakegen.date_of_birth()
            if datedeb<=dn<=datefin:
                break
        gnr= random.choice(["M","F"])
        nt=Agent.fakegen.phone_number()
        ml=Agent.fakegen.email()
        return Agent(nm,prnm,adr,dn,gnr,nt,ml)
    def getCSVformat():
        return("id",
        "nom",
        "prenom",
        "adresse",
        "date_naissance",
        "genre",
        "mail",
        "numero_telephone",
        )

    def convertIntoCSV(self):
        return(
            str(self.id),
            str(self.nom),
            str(self.prenom),
            str(self.adresse),
            str(self.date_naissance),
            str(self.genre),
            str(self.numero_telephone),
            str(self.mail)
        )




class Oeuvre():

    id=1
    @classmethod
    def nextid(cls):
        toret=cls.id
        cls.id =cls.id+1
        return toret 

    def __init__(self,titre:str,descript:str,date_sortie:date):
        self.id=Oeuvre.nextid()
        self.titre=titre
        self.descript=descript
        self.date_sortie=date_sortie
    # No generate, oeuvre are harvested from file !
    # No Convert to CSV


class ProducteurStudio():

    id=1
    @classmethod
    def nextid(cls):
        toret=cls.id
        cls.id =cls.id+1
        return toret 

    def __init__(self,nom,capital):
        self.id= ProducteurStudio.nextid()
        self.nom=nom
        self.capital=capital

    @classmethod
    def generate(cls,*,capital):
        pass
    
    def getCSVformat():
        return ("id","nom","capital")

    def convertIntoCSV(self):
        return (str(self.id),str(self.nom),str(self.capital))


class Artiste():
    fakegen = faker.Faker('fr-FR')
    id=1
    @classmethod
    def nextid(cls):
        toret=cls.id
        cls.id =cls.id+1
        return toret 

    def __init__(self,nom,prenom,adresse,date_naissance:date,genre,numero_telephone,mail):
        self.id=Artiste.nextid()
        self.nom=nom
        self.prenom = prenom
        self.adresse = adresse
        self.date_naissance = date_naissance
        self.genre = genre
        self.numero_telephone = numero_telephone
        self.mail= mail
    
    @classmethod
    def generate(cls,datedeb:date,datefin:date):
        nm= Artiste.fakegen.last_name()
        prnm= Artiste.fakegen.first_name()
        adr= Artiste.fakegen.address().replace('\n','')
        dn = None
        while True :
            dn:date=Artiste.fakegen.date_of_birth()
            if datedeb<=dn<=datefin:
                break

        gnr= random.choice(["M","F"])
        nt=Artiste.fakegen.phone_number()
        ml=Artiste.fakegen.email()
        return Artiste(nm,prnm,adr,dn,gnr,nt,ml)

    @staticmethod
    def getCSVformat():
        return ("id","nom","prenom","adresse","date_naissance","genre","numero_telephone","mail") 

    def convertIntoCSV(self):
        return(
            str(self.id),
            str(self.nom),
            str(self.prenom),
            str(self.adresse),
            str(self.date_naissance),
            str(self.genre),
            str(self.numero_telephone),
            str(self.mail)
        )

class Contrat():
    id=1
    @classmethod
    def nextid(cls):
        toret=cls.id
        cls.id =cls.id+1
        return toret 

    def __init__(self,id_prod_studio,id_artiste,id_oeuvre,date_signature,cout):
        self.id=Contrat.nextid()
        self.id_prod_studio= id_prod_studio
        self.id_artiste= id_artiste
        self.id_oeuvre= id_oeuvre
        self.date_signature= date_signature
        self.cout= cout

    def generate(id_prod_studio,id_artiste,id_oeuvre,*,datesign):
        pass
    
    @staticmethod
    def getCSVformat():
        return ("id","id_prod_studio","id_artiste","id_oeuvre","date_signature","cout")

    def convertIntoCSV(self):
        return(
        str(self.id),
        str(self.id_prod_studio),
        str(self.id_artiste),
        str(self.id_oeuvre),
        str(self.date_signature),
        str(self.cout))


class Gestion():
    id=1
    @classmethod
    def nextid(cls):
        toret=cls.id
        cls.id =cls.id+1
        return toret     

    def __init__(self,id_artiste,id_agent,date_debut,date_fin):
        self.id=Gestion.nextid()
        self.id_artiste=id_artiste 
        self.id_agent=id_agent
        self.date_debut=date_debut
        self.date_fin=date_fin
        self.pourcentage=random.randint(1, 100)
    def getCSVformat():
        return ("id","id_artiste","id_agent","date_debut","date_fin", "pourcentage") 
    
    def convertIntoCSV(self):
        return(
        str(self.id),
        str(self.id_artiste),
        str(self.id_agent),
        str(self.date_debut),
        str(self.date_fin), 
        str(self.pourcentage)
        )




# STANDARDIZED FUNCTION TO DATACLASS INTO FILE
def printCSV(fname:str,header:str,tuplist:"list[str]"):
    with open(fname+'.csv', 'w', newline='\n') as f:
        wcsv = csv.writer(f)
        wcsv.writerow(header)
        for objtup in tuplist:
            wcsv.writerow(objtup.convertIntoCSV()) # ALL DATA CLASS SHALL HAVE THIS FUNCTION

def main():
    if len(sys.argv)!=3:
        print("file path not specified/too many arguments first argument path to oeuvre.csv second argument folder where you want generated files to besaved")
        return
    # load data 
    with open(sys.argv[1],mode='r') as srcfile:
        manyrows =csv.reader(srcfile,delimiter=',')
        header= manyrows.__next__() # fetching header 
        if  header[0] !="titre" or header[1] !="date_sortie" or header[2] !="descript" :
            print(f"WRONG FILE HEADER INCORRECT : {header}")
            return

        for row in manyrows:
            OEUVRELS.append(Oeuvre(titre=row[0],descript=row[2],date_sortie=datetime.strptime(row[1],"%d-%m-%Y").date()))
        
        
        print(f'loaded successfully {len(OEUVRELS)} rows')

    for birthdecade in range(1930,2010,10):
        for i in range (0,30):
            ARTISTELS.append(Artiste.generate(datedeb=date(year=birthdecade-10,month=1,day=1),datefin=date(year=birthdecade,month=1,day=1)))
        # wayyyy less agent than artist and they must be older than them  ! 
        for i in range (0,7):
            AGENTLS.append(Agent.generate(datedeb=date(year=birthdecade-20,month=1,day=1),datefin=date(year=birthdecade-10,month=1,day=1)))
    print(f'created successfully {len(ARTISTELS)} artist')
    print(f'created successfully {len(AGENTLS)} agent')

    # generate director
    PRODUCTEURLS.append(ProducteurStudio("Universal",0))
    PRODUCTEURLS.append(ProducteurStudio("20th Fox Century",0))
    PRODUCTEURLS.append(ProducteurStudio("Labyrinthe Film",0))
    PRODUCTEURLS.append(ProducteurStudio("EuropaCorp",0))
    PRODUCTEURLS.append(ProducteurStudio("Canal+",0))
    PRODUCTEURLS.append(ProducteurStudio("Columbia Pictures",0))
    PRODUCTEURLS.append(ProducteurStudio("Disney",0))
    PRODUCTEURLS.append(ProducteurStudio("Pixar",0))
    print(f'created successfully {len(PRODUCTEURLS)} producers')
    
    # generating gestion
    print("beginning to generate AGENT contrat ")
    artdbgcount=0
    for art in ARTISTELS:
        artdbgcount=artdbgcount+1
        if(artdbgcount%100==0):
            print(f"treated {artdbgcount} couple agent/artist")
        howmanyagent=2 # how many agent in the artist lifetime he will be represented by.
        if art.date_naissance.year <1950 :
            howmanyagent = 4
        elif art.date_naissance.year <1970 :
            howmanyagent = 4
        elif art.date_naissance.year <1990 :
            howmanyagent = 3
        else :# <2010
            howmanyagent = 2

        lstagent:"list[Agent]"=[] #list of agent that will reprent the artist
        while len(lstagent)<howmanyagent: 
            agtotest:Agent= AGENTLS[random.randint(0,len(AGENTLS)-1)]
            if not ( 5 < art.date_naissance.year-agtotest.date_naissance.year< 35) or agtotest in lstagent  :
                continue
            lstagent.append(agtotest)

        anndebutcarriere = random.randint(art.date_naissance.year+14,art.date_naissance.year+40) # year of the career start of the artist
        annfincarriere = random.randint(art.date_naissance.year+41,art.date_naissance.year+80) # year of the career end of the artist

        lstannecontratagent=[anndebutcarriere]
        for i in range (0,howmanyagent):
            lstannecontratagent.append(random.randint(anndebutcarriere+1,annfincarriere))
        lstannecontratagent.sort()
        lstdatecontratagent=[]

        for ann in lstannecontratagent:
            datetoadd = date(year=ann,month=random.randint(1,12),day=random.randint(1,28))
            if len(lstdatecontratagent)> 0:
                while lstdatecontratagent[-1] == datetoadd:
                    datetoadd = date(year=ann,month=random.randint(1,12),day=random.randint(1,28))
            lstdatecontratagent.append(datetoadd) # day max 28 no problem with february or 30 day month 
            
        lstdatecontratagent.sort()
        
        posagent=0 # int to get start and end of agent contract.
        for ag in lstagent:
            GESTIONLS.append(Gestion(art.id,ag.id,date_debut=lstdatecontratagent[posagent],date_fin=lstdatecontratagent[posagent+1]))
            posagent= posagent+1

    print("beginning to match oeuvre with artist and producers ")
    # generating contrat
    dbgcounter=0
    for oeuv in OEUVRELS:
        dbgcounter= dbgcounter+1
        if dbgcounter % 100 == 0 :
            print(f"treated {dbgcounter} Oeuvre")
        # to generate contrat
        # first choose producer 
        selectedproducer:ProducteurStudio = random.choice(PRODUCTEURLS)
        # then choose random number of  artist 
        nbartist= random.randint(3,15)
        selectedartist:"list[Artiste]"=[]# list of artist which will play in the film 
        
        while len(selectedartist)< nbartist:
            #if dbgcounter > 1025:
            #    print(f"DEBUG {dbgcounter} {str(oeuv.titre)} {len(selectedartist)} < {nbartist} ")
            artisttocheck:Artiste = ARTISTELS[random.randint(0,len(ARTISTELS)-1)]
            if artisttocheck not in selectedartist and 14<  oeuv.date_sortie.year -artisttocheck.date_naissance.year  < 70   :
                selectedartist.append(artisttocheck)
            else :continue
        # age between 14 and 65 at film release
        moneytoaddtoproducer = 0
        for sa in selectedartist:
            # choose a cost for the artist contract 
            contractcost = random.randint(500,5000000)
            # add contract cost to moneytoaddtoproducer
            CONTRATLS.append(Contrat(
                id_prod_studio=selectedproducer.id,
                id_artiste=sa.id,
                id_oeuvre=oeuv.id,
                date_signature= oeuv.date_sortie - timedelta(days=random.randint(-50,-5))
                ,cout=contractcost
                ))
            moneytoaddtoproducer+=contractcost
            # choose random number between 1 and 49 to mutiply  with, and add to, moneytoaddtoproducer  
            moneytoaddtoproducer+= moneytoaddtoproducer * random.randint(1,49)
            selectedproducer.capital += moneytoaddtoproducer 


    printCSV(sys.argv[2]+"/artiste",Artiste.getCSVformat(),ARTISTELS)
    printCSV(sys.argv[2]+"/producteur",ProducteurStudio.getCSVformat(),PRODUCTEURLS)
    printCSV(sys.argv[2]+"/contrat",Contrat.getCSVformat(),CONTRATLS)
    printCSV(sys.argv[2]+"/agent",Agent.getCSVformat(),AGENTLS)
    printCSV(sys.argv[2]+"/gestion",Gestion.getCSVformat(),GESTIONLS)


# transform everything back to csv
# enjoy  


if __name__ =='__main__':
    main()