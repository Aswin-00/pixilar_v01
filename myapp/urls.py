
from django.urls import path
from . import views
urlpatterns = [
    path('',views.index),
    path('logout',views.user_logout),
    path('search_results',views.search_results,name='search_results'),
    path('upload/', views.ImageCreateView.as_view(), name='upload_image'),


]

