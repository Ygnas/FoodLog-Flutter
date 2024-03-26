import 'package:food_log/src/models/listing.dart';
import 'package:test/test.dart';

void main() {
  group('Listing Tests', () {
    test('Listing toJson() should return correct JSON', () {
      final listing = Listing(
        title: 'Test Title',
        description: 'Test Description',
        image: 'test_image.jpg',
        type: ListingType.breakfast,
        likes: ['user1@example.com', 'user2@example.com'],
        comments: [
          Comment(comment: 'Nice!', email: 'user3@example.com'),
          Comment(comment: 'Great!', email: 'user4@example.com'),
        ],
      );

      final json = listing.toJson();

      expect(json['title'], 'Test Title');
      expect(json['description'], 'Test Description');
      expect(json['image'], 'test_image.jpg');
      expect(json['type'], 'breakfast');
      expect(json['likes'], [
        {'email': 'user1@example.com'},
        {'email': 'user2@example.com'},
      ]);
      expect(json['comments'], [
        {
          'comment': 'Nice!',
          'email': 'user3@example.com',
          'created_at': anything
        },
        {
          'comment': 'Great!',
          'email': 'user4@example.com',
          'created_at': anything
        },
      ]);
    });

    test('Listing.fromJson() should parse JSON correctly', () {
      final json = {
        'title': 'Test Title',
        'description': 'Test Description',
        'image': 'test_image.jpg',
        'type': 'breakfast',
        'likes': [
          {'email': 'user1@example.com'},
          {'email': 'user2@example.com'},
        ],
        'comments': [
          {
            'comment': 'Nice!',
            'email': 'user3@example.com',
            'created_at': '2024-03-25T11:28:07.6412334Z'
          },
          {
            'comment': 'Great!',
            'email': 'user4@example.com',
            'created_at': '2024-03-25T11:28:07.6412334Z'
          },
        ],
        'shared': false,
        'created_at': '2024-03-25T11:28:07.6412334Z',
        'updated_at': '2024-03-25T11:28:07.6412334Z',
      };

      final listing = Listing.fromJson(json);

      expect(listing.title, 'Test Title');
      expect(listing.description, 'Test Description');
      expect(listing.image, 'test_image.jpg');
      expect(listing.type, ListingType.breakfast);
      expect(listing.likes, ['user1@example.com', 'user2@example.com']);
      expect(listing.comments.length, 2);
      expect(listing.comments[0].comment, 'Nice!');
      expect(listing.comments[0].email, 'user3@example.com');
      expect(listing.comments[1].comment, 'Great!');
      expect(listing.comments[1].email, 'user4@example.com');
      expect(listing.shared, false);
    });
  });
}
