from allauth.socialaccount.models import SocialApp
from django.contrib.auth.models import User
from django.core.management.base import BaseCommand
from django.core.management import call_command

from decouple import config

class Command(BaseCommand):
    help = 'Add social providers to the database'
    

    def handle(self, *args, **kwargs):
        username ='admin'
        email = 'bootpq@gmail.com'
        password = 'admin'

        social_apps = [
            {
                'provider': 'google',  # Use lowercase for the provider identifier
                'provider_id':config('GOOGLE_SSO_PROJECT_ID'),
                'name': 'Google',
                'client_id': config('GOOGLE_SSO_CLIENT_ID'),
                'secret': config('GOOGLE_CLIENT_SECRET'),
            }
        ]
        
         # set all database 
        call_command('makemigrations')
        call_command('migrate')
        call_command('collectstatic')

            
           
        
        if not User.objects.filter(username=username).exists():
            
            # create superuser 
            call_command('createsuperuser', username=username, email=email, interactive=False)
            
            # Set the password
            user = User.objects.get(username=username)
            user.set_password(password)
            user.save()
            # collectstatic

            self.stdout.write(self.style.SUCCESS(f'Superuser "{username}" created successfully with password!'))
        else:
            self.stdout.write(self.style.WARNING(f'Superuser "{username}" already exists.'))
            
            

        for app_data in social_apps:
            # Extract site 
            
            # Get or create the SocialApp
            app, created = SocialApp.objects.get_or_create(**app_data)

            if created:
                self.stdout.write(self.style.SUCCESS(f'SocialApp "{app.name}" added successfully!'))
            else:
                self.stdout.write(self.style.WARNING(f'SocialApp "{app.name}" already exists.'))

        
        