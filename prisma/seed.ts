import console from 'node:console';
import { PrismaClient, Permission } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  const initializers = [
    initializeRolesAndPermissions,
    initializeLanguages
  ];

  for (const initializer of initializers) {
    try {
      await initializer();
      console.log(`${initializer.name} completed successfully.`);
    } catch (error) {
      console.error(`Error initializing ${initializer.name}:`, error);
      throw error;
    }
  }
}

main()
  .then(() => console.log('Seeding complete'))
  .catch((error: Error) => {
    console.error(error);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });


  /**
 * Initialize default roles and permissions in the database
 */
async function initializeRolesAndPermissions() {
  // Create system roles
  const adminRole = await prisma.role.upsert({
    create: {
      name: 'System Administrator',
      description: 'Full access to all system functions',
      isSystem: true
    },
    update: {},
    where: {
      name: 'System Administrator'
    }
  });

  const moderatorRole = await prisma.role.upsert({
    create: {
      name: 'Moderator',
      description: 'Can moderate content but cannot change system settings',
      isSystem: true
    },
    update: {},
    where: {
      name: 'Moderator'
    }
  });

  const userRole = await prisma.role.upsert({
    create: {
      name: 'User',
      description: 'Standard user account',
      isSystem: true
    },
    update: {},
    where: {
      name: 'User'
    }
  });

  // Create household roles
  const householdOwnerRole = await prisma.role.upsert({
    create: {
      name: 'Household Owner',
      description: 'Owner of a household with full control',
      isSystem: true
    },
    update: {},
    where: {
      name: 'Household Owner'
    }
  });

  const householdAdminRole = await prisma.role.upsert({
    create: {
      name: 'Household Admin',
      description: 'Can manage household settings and members',
      isSystem: true
    },
    update: {},
    where: {
      name: 'Household Admin'
    }
  });

  const householdMemberRole = await prisma.role.upsert({
    create: {
      name: 'Household Member',
      description: 'Regular household member',
      isSystem: true
    },
    update: {},
    where: {
      name: 'Household Member'
    }
  });

  const householdGuestRole = await prisma.role.upsert({
    create: {
      name: 'Household Guest',
      description: 'Limited access household guest',
      isSystem: true
    },
    update: {},
    where: {
      name: 'Household Guest'
    }
  });

  // Grant permissions to admin role (all permissions)
  const allPermissions = Object.values(Permission);

  for (const permission of allPermissions) {
    await prisma.rolePermission.upsert({
      create: {
        roleId: adminRole.id,
        permission
      },
      update: {},
      where: {
        roleId_permission: {
          roleId: adminRole.id,
          permission
        }
      }
    });
  }

  // Grant specific permissions to moderator role
  const moderatorPermissions = [
    Permission.ViewUsers,
    Permission.ViewGameCollection,
    Permission.ViewGameSession,
    Permission.ModerateContent
  ];

  for (const permission of moderatorPermissions) {
    await prisma.rolePermission.upsert({
      create: {
        roleId: moderatorRole.id,
        permission
      },
      update: {},
      where: {
        roleId_permission: {
          roleId: moderatorRole.id,
          permission
        }
      }
    });
  }

  // Grant household owner permissions
  const householdOwnerPermissions = [
    Permission.UpdateHousehold,
    Permission.DeleteHousehold,
    Permission.ManageHouseholdMembers,
    Permission.InviteToHousehold,
    Permission.CreateEvent,
    Permission.CreateGameSession,
    Permission.CreateCampaign
  ];

  for (const permission of householdOwnerPermissions) {
    await prisma.rolePermission.upsert({
      create: {
        roleId: householdOwnerRole.id,
        permission
      },
      update: {},
      where: {
        roleId_permission: {
          roleId: householdOwnerRole.id,
          permission
        }
      }
    });
  }

  // Grant household admin permissions
  const householdAdminPermissions = [
    Permission.UpdateHousehold,
    Permission.ManageHouseholdMembers,
    Permission.CreateEvent,
    Permission.CreateGameSession,
    Permission.CreateCampaign,
    Permission.InviteToHousehold,
  ];

  for (const permission of householdAdminPermissions) {
    await prisma.rolePermission.upsert({
      create: {
        roleId: householdAdminRole.id,
        permission
      },
      update: {},
      where: {
        roleId_permission: {
          roleId: householdAdminRole.id,
          permission
        }
      }
    });
  }

  // Grant household member permissions
  const memberPermissions = [
    Permission.ViewHousehold,
    Permission.JoinEvent,
    Permission.ViewEvent,
    Permission.JoinGameSession,
    Permission.CreateGameSession,
    Permission.RecordGamePlay
  ];

  for (const permission of memberPermissions) {
    await prisma.rolePermission.upsert({
      create: {
        roleId: householdMemberRole.id,
        permission
      },
      update: {},
      where: {
        roleId_permission: {
          roleId: householdMemberRole.id,
          permission
        }
      }
    });
  }

  // Grant household guest permissions
  const guestPermissions = [
    Permission.ViewHousehold,
    Permission.JoinEvent,
    Permission.JoinGameSession
  ];

  for (const permission of guestPermissions) {
    await prisma.rolePermission.upsert({
      create: {
        roleId: householdGuestRole.id,
        permission
      },
      update: {},
      where: {
        roleId_permission: {
          roleId: householdGuestRole.id,
          permission
        }
      }
    });
  }

  // Grant standard user permissions
  const standardUserPermissions = [
    Permission.ViewOwnProfile,
    Permission.UpdateOwnProfile,
    Permission.ViewPublicContent,
    Permission.JoinHousehold
  ];

  for (const permission of standardUserPermissions) {
    await prisma.rolePermission.upsert({
      create: {
        roleId: userRole.id,
        permission
      },
      update: {},
      where: {
        roleId_permission: {
          roleId: userRole.id,
          permission
        }
      }
    });
  }
}


async function initializeLanguages() {
  const languages = [
    {
      name: 'English',
      abbreviation: 'en',
      code: 'eng'
    },
    {
      name: 'Spanish',
      abbreviation: 'es',
      code: 'spa'
    },
    {
      name: 'French',
      abbreviation: 'fr',
      code: 'fra'
    }
  ];

  for (const language of languages) {
    await prisma.language.upsert({
      create: language,
      update: {},
      where: {
        abbreviation: language.abbreviation
      }
    });
  }
}
