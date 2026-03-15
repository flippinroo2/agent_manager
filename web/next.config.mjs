/** @type {import('next').NextConfig} */
export default {
  distDir: process.env.NEXT_BUILD_DIR || '.next',
  transpilePackages: ['thepopebot'],
  serverExternalPackages: ['better-sqlite3', 'drizzle-orm', 'bindings'],
  webpack: (config, { isServer }) => {
    if (isServer) {
      config.externals = config.externals || [];
      config.externals.push('better-sqlite3', 'bindings');
    }
    return config;
  },
};
