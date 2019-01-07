from django.db import models
from taggit.managers import TaggableManager
from django.utils import timezone

age_ratingList = (
    [1, '0+'],
    [2, '6+'],
    [3, '12+'],
    [4, '16+'],
    [5, '18+']
)

class event(models.Model):
    title = models.CharField(max_length=200)
    published_date = models.DateTimeField(
            blank=True, null=True)
    age_rating = models.IntegerField(choices=age_ratingList, default=5)
    paid = models.BooleanField(default=0)
    price = models.PositiveSmallIntegerField()
    hashtags = TaggableManager()
    description = models.TextField(max_length=9999)
    mainPhoto = models.FileField(upload_to='events /mainPhotos /%Y/%m/%d/')
    morePhotos = models.FileField(upload_to='events /morePhotos /%Y/%m/%d/')
    created_date = models.DateTimeField(
            default=timezone.now)
    author = models.ForeignKey('auth.User', on_delete=models.CASCADE)

    def publish(self):
        self.published_date = timezone.now()
        self.save()

    def __str__(self):
        return self.title