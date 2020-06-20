import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart' as matcher;
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDatasourceImpl datasource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    datasource = NumberTriviaRemoteDatasourceImpl(client: mockHttpClient);
  });

  void setupMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setupMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      '''should perform a GET request on a URL with number
      being the endpoint and with appication/json header''',
      () async {
        // arrange
        setupMockHttpClientSuccess200();
        // act
        datasource.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockHttpClient.get('http://numberapi.com/$tNumber', headers: {
          'Content-Type': 'application/json',
        }));
      },
    );

    test(
      'should return NumberTrivia when response code is 200 (success)',
      () async {
        // arrange
        setupMockHttpClientSuccess200();
        // act
        final result = await datasource.getConcreteNumberTrivia(tNumber);
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setupMockHttpClientFailure404();
        // act
        final call = datasource.getConcreteNumberTrivia;
        // assert
        expect(() => call(tNumber),
            throwsA(matcher.TypeMatcher<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      '''should perform a GET request on a URL with number
      being the endpoint and with appication/json header''',
      () async {
        // arrange
        setupMockHttpClientSuccess200();
        // act
        datasource.getRandomNumberTrivia();
        // assert
        verify(mockHttpClient.get('http://numberapi.com/random', headers: {
          'Content-Type': 'application/json',
        }));
      },
    );

    test(
      'should return NumberTrivia when response code is 200 (success)',
      () async {
        // arrange
        setupMockHttpClientSuccess200();
        // act
        final result = await datasource.getRandomNumberTrivia();
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setupMockHttpClientFailure404();
        // act
        final call = datasource.getRandomNumberTrivia;
        // assert
        expect(() => call(),
            throwsA(matcher.TypeMatcher<ServerException>()));
      },
    );
  });
}
