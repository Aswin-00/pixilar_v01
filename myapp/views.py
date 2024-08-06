from django.shortcuts import render,redirect 
# logoutn
from django.contrib.auth import logout
from .forms  import ImageUploadForm
from .models import Image 
from django.contrib.auth.mixins import LoginRequiredMixin
from django.views.generic.edit import CreateView
from django.contrib.auth.decorators import login_required




# Create your views here.
def index(request):
    user_images = Image.objects.all().order_by('-uploaded_at')
    # print(user_images)
    context={
        "user_images":user_images,
    }
    return render(request ,"index.html",context) 



def user_logout(request):
    logout(request)
    return redirect('/')



#search_results
def search_results(request):
    pass


#image uploadfrom 
class ImageCreateView(LoginRequiredMixin, CreateView):
    model = Image
    form_class = ImageUploadForm
    template_name = 'uploadimage.html'  # Template to render the form
    success_url = '/'  # Redirect after a successful upload

    def form_valid(self, form):
        # Set the user before saving the form
        form.instance.user = self.request.user
        return super().form_valid(form)
    
    def get_context_data(self, **kwargs):
        # Get the existing context from the superclass method
        context = super().get_context_data(**kwargs)
        # Add the user's images ordered by upload date
        context['user_images'] = Image.objects.filter(user=self.request.user).order_by('-uploaded_at')
        return context
    
