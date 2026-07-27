import 'package:flutter_test/flutter_test.dart';
import 'package:sra_hotel/features/auth/domain/entities/user_entity.dart';
import 'package:sra_hotel/features/auth/domain/usecases/register_usecase.dart';
import 'login_usecase_test.dart';

void main() {
  group('RegisterUseCase Tests', () {
    test('devrait enregistrer un particulier avec succès', () async {
      const mockUser = UserEntity(
        id: '200',
        login: 'jean.dupont@email.com',
        role: 'CLIENT',
        nom: 'Dupont',
        prenoms: 'Jean',
      );
      final repository = MockAuthRepository(mockUser: mockUser);
      final useCase = RegisterUseCase(repository);

      final result = await useCase.registerParticulier(
        const RegisterParticulierParams(
          email: 'jean.dupont@email.com',
          password: 'Password123',
          nom: 'Dupont',
          prenoms: 'Jean',
          telephone: '+22507070707',
          sexe: 'M',
          pays: 'Côte d\'Ivoire',
          adresse: 'Abidjan',
        ),
      );

      expect(result.id, '200');
      expect(result.nom, 'Dupont');
      expect(result.prenoms, 'Jean');
    });

    test('devrait enregistrer une entreprise avec succès', () async {
      const mockUser = UserEntity(
        id: '300',
        login: 'contact@corp.com',
        role: 'CLIENT',
        nom: 'Corp SARL',
      );
      final repository = MockAuthRepository(mockUser: mockUser);
      final useCase = RegisterUseCase(repository);

      final result = await useCase.registerCompany(
        const RegisterCompanyParams(
          email: 'contact@corp.com',
          password: 'Password123',
          companyName: 'Corp SARL',
          telephone: '+22501010101',
          pays: 'Côte d\'Ivoire',
          adresse: 'Abidjan',
          isExterne: false,
        ),
      );

      expect(result.id, '300');
      expect(result.login, 'contact@corp.com');
    });
  });
}
